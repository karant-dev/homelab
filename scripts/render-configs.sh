#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT_DIR"

if [[ ! -f .env ]]; then
  echo "[error] .env not found. Copy .env.example to .env first."
  exit 1
fi

# shellcheck disable=SC1091
source .env

: "${DOMAIN:?DOMAIN is required in .env}"

export DOMAIN
export HOMER_ORIGIN="${HOMER_ORIGIN:-https://homelab.${DOMAIN}}"
export HOMER_TITLE="${HOMER_TITLE:-My Homelab}"

mkdir -p "$CONFIG_ROOT/homer"

envsubst < configs/Caddyfile.template > configs/Caddyfile
envsubst < configs/homer.yml.template > "$CONFIG_ROOT/homer/config.yml"
cp "$CONFIG_ROOT/homer/config.yml" configs/homer.yml

echo "[ok] Rendered configs/Caddyfile and $CONFIG_ROOT/homer/config.yml"
