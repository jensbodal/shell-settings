#!/bin/bash
# litellm_setup.sh  —  install OR uninstall LiteLLM proxy as a user-service
set -euo pipefail

ACTION="install"
[[ "${1:-}" == "--uninstall" ]] && ACTION="uninstall"

LOG_DIR="$HOME/.local/lite-llm"
CONFIG="$LOG_DIR/config.yaml"
LOGFILE="$LOG_DIR/lite-llm.log"
SERVICE_NAME="litellm"

systemd_ok() { command -v systemctl >/dev/null && systemctl --user >/dev/null 2>&1; }
macos_ok()   { [[ "$OSTYPE" == "darwin"* ]]; }

clean_transient_unit() {
  TR_UNIT="/run/user/$(id -u)/systemd/transient/${SERVICE_NAME}.service"
  [[ -e $TR_UNIT ]] && { systemctl --user stop "$SERVICE_NAME" || true; rm -f "$TR_UNIT"; }
}

remove_systemd() {
  clean_transient_unit
  systemctl --user stop "$SERVICE_NAME" 2>/dev/null || true
  systemctl --user disable "$SERVICE_NAME" 2>/dev/null || true
  rm -f "$HOME/.config/systemd/user/${SERVICE_NAME}.service"
  systemctl --user daemon-reload
}

remove_launchd() {
  launchctl unload -w "$HOME/Library/LaunchAgents/com.${SERVICE_NAME}.plist" 2>/dev/null || true
  rm -f "$HOME/Library/LaunchAgents/com.${SERVICE_NAME}.plist"
}

remove_nohup() {
  pkill -f "litellm.*config.yaml" 2>/dev/null || true
}

case "$ACTION" in
# =============================== UNINSTALL ==================================
uninstall)
  echo "Uninstalling LiteLLM user-service …"
  if systemd_ok;      then remove_systemd
  elif macos_ok;      then remove_launchd
  else                     remove_nohup
  fi

  read -rp "Delete $LOG_DIR (config & logs)? [y/N]: " DEL
  [[ "$DEL" =~ ^[Yy]$ ]] && rm -rf "$LOG_DIR"

  read -rp "Remove litellm Python package? [y/N]: " DELPKG
  [[ "$DELPKG" =~ ^[Yy]$ ]] && python3 -m pip uninstall -y litellm

  echo "✅ LiteLLM service removed."
  exit 0
  ;;
# =============================== INSTALL ====================================
install)
  command -v python3 >/dev/null || { echo "python3 missing – install it first."; exit 1; }
  python3 -m pip install --upgrade "litellm[proxy]"
  mkdir -p "$LOG_DIR"

  # ---------- ask which models to pre-seed ----------
  echo "Model setup:
    1) Dummy test endpoint (offline)
    2) OpenAI
    3) Ollama local
    4) Skeleton (edit later)"
  read -rp "Choose [1-4]: " OPT
  case "$OPT" in
    1) cat >"$CONFIG" <<'YAML'
model_list:
  - model_name: fake-openai-endpoint
    litellm_params:
      model: openai/fake
      api_key: fake-key
      api_base: https://exampleopenaiendpoint-production.up.railway.app/
YAML
       ;;
    2) read -rp "OpenAI API key (sk-…): " OAI_KEY
       cat >"$CONFIG" <<YAML
model_list:
  - model_name: openai/gpt-4o-mini
    litellm_params:
      model: gpt-4o-mini
      api_key: $OAI_KEY
YAML
       ;;
    3) read -rp "Ollama host [http://127.0.0.1:11434]: " O_HOST
       O_HOST=${O_HOST:-http://127.0.0.1:11434}
       cat >"$CONFIG" <<YAML
model_list:
  - model_name: ollama/mistral-7b
    litellm_params:
      model: mistral:7b-instruct
      api_base: $O_HOST
YAML
       ;;
    4) cat >"$CONFIG" <<'YAML'
# edit models here, then restart the service
model_list: []
YAML
       ;;
    *) echo "Invalid choice"; exit 1 ;;
  esac

  # ---------- create + start service ----------
  if systemd_ok; then
    clean_transient_unit
    mkdir -p "$HOME/.config/systemd/user"
    cat >"$HOME/.config/systemd/user/${SERVICE_NAME}.service" <<UNIT
[Unit]
Description=LiteLLM proxy
After=network.target
[Service]
ExecStart=$(command -v litellm) --config $CONFIG --host 0.0.0.0 --port 4000
Restart=always
StandardOutput=append:$LOGFILE
StandardError=append:$LOGFILE
[Install]
WantedBy=default.target
UNIT
    systemctl --user daemon-reload
    systemctl --user enable --now --force "$SERVICE_NAME"

  elif macos_ok; then
    AGENT="$HOME/Library/LaunchAgents/com.${SERVICE_NAME}.plist"
    cat >"$AGENT" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
 <dict>
  <key>Label</key><string>com.${SERVICE_NAME}</string>
  <key>ProgramArguments</key>
  <array>
   <string>$(command -v litellm)</string>
   <string>--config</string><string>$CONFIG</string>
   <string>--host</string><string>0.0.0.0</string>
   <string>--port</string><string>4000</string>
  </array>
  <key>StandardOutPath</key><string>$LOGFILE</string>
  <key>StandardErrorPath</key><string>$LOGFILE</string>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
 </dict>
</plist>
PLIST
    launchctl load -w "$AGENT"

  else
    nohup litellm --config "$CONFIG" --host 0.0.0.0 --port 4000 \
         >>"$LOGFILE" 2>&1 &
  fi

  sleep 2
  curl -sf http://localhost:4000/health && echo "✅ LiteLLM healthy"
  echo "Logs → $LOGFILE"
  ;;
esac

