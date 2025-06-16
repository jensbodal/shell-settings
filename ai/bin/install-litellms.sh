#!/usr/bin/env -S pkgx +curl.se +gopass +postgresql.org bash>=5 -euo pipefail
# ───────────────────────────  LiteLLM ▸ Container ▸ Postgres  ──────────────────────────
# Container-based bootstrap — avoids all pipx/Prisma dependency issues
# Uses official LiteLLM container with pre-built Prisma binaries


# ╭─ CONFIG ───────────────────────────────────────────────────────────────────╮
DB_HOST="$(gopass show db/rag_host)"           # Postgres host (Tailscale DNS)
DB_USER="litellm"                              # DB role + Prisma owner
DB_NAME="$DB_USER"                             # Set if DB ≠ user
GOPASS_PATH="db/${DB_USER}@${DB_HOST}"         # gopass entry (contains password)
PORT=4000                                      # litellm proxy listen port
CONFIG_FILE="./litellm.config.yaml"            # LiteLLM config file
CONTAINER_NAME="litellm-proxy"                 # Container name
IMAGE="ghcr.io/berriai/litellm:main-stable"    # Official stable image
APP_NAME="shell-settings_${CONTAINER_NAME}"    # Canonical 'appName'
APP_VERSION="$(basename "$0")_v1"              # Version of our app
OR_APP_NAME="${APP_NAME}_${APP_VERSION}"       # Unique string for OR deployment

# ╰─────────────────────────────────────────────────────────────────────────────╯

# ── Colours ───────────────────────────────────────────────────────────────────
if command -v tput &>/dev/null && [ -t 1 ]; then
  BOLD=$(tput bold) RED=$(tput setaf 1) GRN=$(tput setaf 2)
  YLW=$(tput setaf 3) CYN=$(tput setaf 6) RST=$(tput sgr0)
else BOLD="" RED="" GRN="" YLW="" CYN="" RST=""; fi
say()  { printf "%b%s%b\n" "${CYN}" "$1" "${RST}"; }
warn() { printf "%b%s%b\n" "${YLW}" "$1" "${RST}"; }
err()  { printf "%b%s%b\n" "${RED}" "$1" "${RST}" >&2; }

# ── Detect container runtime ──────────────────────────────────────────────────
if command -v finch &>/dev/null; then
  CONTAINER_CMD="finch"
elif command -v podman &>/dev/null; then
  CONTAINER_CMD="podman"
elif command -v docker &>/dev/null; then
  CONTAINER_CMD="docker"
else
  err "No container runtime found. Please install finch, podman, or docker."
  exit 1
fi

say "Using container runtime: $CONTAINER_CMD"

# ── 0. Stop any existing containers ───────────────────────────────────────────
existing_container=$($CONTAINER_CMD ps -aq --filter "name=$CONTAINER_NAME" 2>/dev/null || true)
port_conflict=$($CONTAINER_CMD ps --format "table {{.Names}}\t{{.Ports}}" | grep ":$PORT->" || true)

if [[ -n $existing_container || -n $port_conflict ]]; then
  warn "Existing LiteLLM container or port conflict detected:"
  [[ -n $existing_container ]] && warn "  • Container: $CONTAINER_NAME"
  [[ -n $port_conflict ]] && warn "  • Port conflict: $port_conflict"
  echo
  read -rp "${YLW}Stop and replace? [y/N] ${RST}" ans
  if [[ ${ans:-n} =~ ^[Yy]$ ]]; then
    [[ -n $existing_container ]] && $CONTAINER_CMD rm -f "$CONTAINER_NAME" || true
    # Kill anything using our port
    if [[ -n $port_conflict ]]; then
      container_using_port=$(echo "$port_conflict" | awk '{print $1}')
      $CONTAINER_CMD stop "$container_using_port" 2>/dev/null || true
    fi
  else
    err "Aborting."
    exit 1
  fi
fi

# ── Preview ───────────────────────────────────────────────────────────────────
cat <<EOF
${BOLD}LiteLLM Container ➜ Postgres bootstrap${RST}

${GRN}Container Setup${RST}
  runtime     = ${CONTAINER_CMD}
  image       = ${IMAGE}
  name        = ${CONTAINER_NAME}
  port        = ${PORT}

${GRN}Target Postgres${RST}
  host        = ${DB_HOST}
  user        = ${DB_USER}
  db          = ${DB_NAME}

${GRN}Configuration${RST}
  config_file = ${CONFIG_FILE}
  gopass_path = ${GOPASS_PATH}

${GRN}Planned steps${RST}
  0. (optional) stop any running containers
  1. Retrieve DB password from gopass
  2. Create database if missing (owner = ${DB_USER})
  3. Verify config file exists
  4. Pull latest LiteLLM container image
  5. Launch container with database and config
EOF
read -rp "${YLW}Proceed? [y/N] ${RST}" confirm
[[ ${confirm:-n} =~ ^[Yy]$ ]] || { say "Aborted."; exit 0; }

# ── 1. Retrieve password from gopass ──────────────────────────────────────────
say "1️⃣  Retrieving DB password…"
DB_PASS=$(gopass show -o "$GOPASS_PATH")

DATABASE_URL="postgresql://${DB_USER}:${DB_PASS}@${DB_HOST}:5432/${DB_NAME}"

# ── 2. Ensure database exists ────────────────────────────────────────────────
say "2️⃣  Ensuring database '${DB_NAME}' exists…"
PSQL_CMD=(psql)
PGPASSWORD="$DB_PASS" "${PSQL_CMD[@]}" -h "$DB_HOST" -U "$DB_USER" \
  -tc "SELECT 1 FROM pg_database WHERE datname = '${DB_NAME}'" | grep -q 1 || \
  PGPASSWORD="$DB_PASS" "${PSQL_CMD[@]}" -h "$DB_HOST" -U "$DB_USER" \
  -c "CREATE DATABASE \"${DB_NAME}\" OWNER \"${DB_USER}\";"

# ── 3. Verify config file exists ─────────────────────────────────────────────
say "3️⃣  Verifying config file…"
if [[ ! -f "$CONFIG_FILE" ]]; then
  err "Config file not found: $CONFIG_FILE"
  err "Please ensure the config file exists before running this script."
  exit 1
fi

# Get absolute path for mounting into container
CONFIG_ABS_PATH=$(realpath "$CONFIG_FILE")
say "   Config file: $CONFIG_ABS_PATH"

# ── 4. Pull latest container image ───────────────────────────────────────────
say "4️⃣  Pulling latest LiteLLM container image…"
$CONTAINER_CMD pull "$IMAGE"

# ── 5. Launch container ──────────────────────────────────────────────────────
say "5️⃣  Launching LiteLLM container…"

# Check if we need API keys from gopass
OPENROUTER_KEY=""
LITELLM_MASTER_KEY=""
if command -v gopass &>/dev/null && gopass show api/openrouter >/dev/null 2>&1; then
  OPENROUTER_KEY="$(gopass show -o api/openrouter)"
  LITELLM_MASTER_KEY="$(gopass show -o sk/litellm_master_$USER@$(hostname))"
fi

# Launch container with all necessary environment variables and mounts
$CONTAINER_CMD run -d \
  --name "$CONTAINER_NAME" \
  --restart unless-stopped \
  -p "${PORT}:4000" \
  -e "DATABASE_URL=${DATABASE_URL}" \
  -e "OPENROUTER_API_KEY=${OPENROUTER_KEY}" \
  -e "OR_SITE_URL=https://github.com/jensbodal/shell-settings" \
  -e "OR_APP_NAME=${OR_APP_NAME}" \
  -v "${CONFIG_ABS_PATH}:/app/config.yaml:ro" \
  "$IMAGE" \
  --config /app/config.yaml \
  --port 4000 \
  --host 0.0.0.0

# ── 6. Wait for startup and verify ───────────────────────────────────────────
say "6️⃣  Waiting for container to start…"
sleep 5

# Check if container is running
if ! $CONTAINER_CMD ps --filter "name=$CONTAINER_NAME" --filter "status=running" | grep -q "$CONTAINER_NAME"; then
  err "Container failed to start. Checking logs:"
  $CONTAINER_CMD logs "$CONTAINER_NAME"
  exit 1
fi

# Test health endpoint
say "   Testing health endpoint…"
max_attempts=10
attempt=1
while [ $attempt -le $max_attempts ]; do
  if curl -sf -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" "http://localhost:${PORT}/health" >/dev/null 2>&1; then
    say "✅ LiteLLM container is healthy and running!"
    break
  else
    if [ $attempt -eq $max_attempts ]; then
      warn "Health check failed after $max_attempts attempts"
      warn "Container logs:"
      $CONTAINER_CMD logs --tail 20 "$CONTAINER_NAME"
      exit 1
    fi
    say "   Attempt $attempt/$max_attempts failed, retrying in 3s…"
    sleep 3
    ((attempt++))
  fi
done

# ── Final status ──────────────────────────────────────────────────────────────
cat <<EOF

${GRN}✅ LiteLLM Container Successfully Started!${RST}

${BOLD}Container Info:${RST}
  Name: $CONTAINER_NAME
  Port: http://localhost:$PORT
  Runtime: $CONTAINER_CMD

${BOLD}Useful Commands:${RST}
  View logs:    $CONTAINER_CMD logs -f $CONTAINER_NAME
  Stop:         $CONTAINER_CMD stop $CONTAINER_NAME
  Restart:      $CONTAINER_CMD restart $CONTAINER_NAME
  Remove:       $CONTAINER_CMD rm -f $CONTAINER_NAME

${BOLD}Test the proxy:${RST}
  curl http://localhost:$PORT/v1/models
  curl http://localhost:$PORT/health

EOF
