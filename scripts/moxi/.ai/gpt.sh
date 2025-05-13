#!/bin/bash


######## TEMP

mkdir -p ~/podman_bins
cp /opt/homebrew/Cellar/aichat/0.29.0/bin/aichat ~/podman_bins/aichat

########



SESSION_NAME="ai-session-$(date +%Y%m%d-%H%M%S)"
MNT_DIR="$HOME/podman_bins"
LOGS_DIR="./logs"

[[ -d "${LOGS_DIR}" ]] || mkdir -p "${LOGS_DIR}"

podman run --rm -it \
  --name "$SESSION_NAME" \
  --mount type=bind,src="$MNT_DIR",dst=/aichat-bin \
  alpine:latest \
  /aichat-bin/aichat --interactive=true "Hello, bootstrap me!" | tee "${LOGS_DIR}/${SESSION_NAME}.log"
