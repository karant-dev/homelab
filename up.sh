#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [[ ! -f .env ]]; then
  echo "[error] .env not found. Copy .env.example to .env first."
  exit 1
fi

# shellcheck disable=SC1091
source .env

STACK_DIR="docker-compose"
declare -A STACK_FILES=(
  [admin]="admin-stack.yml"
  [ai]="ai-stack.yml"
  [arr]="arr-stack.yml"
  [dev]="dev-stack.yml"
  [home]="home-stack.yml"
  [media]="media-stack.yml"
  [productivity]="productivity-stack.yml"
  [smarthome]="smarthome-stack.yml"
)

usage() {
  echo "Usage: ./up.sh [stack ...]"
  echo "Stacks: ${!STACK_FILES[*]}"
}

select_stacks() {
  local requested=("$@")
  if [[ ${#requested[@]} -eq 0 ]]; then
    printf '%s\n' "${!STACK_FILES[@]}" | sort
    return
  fi

  for stack in "${requested[@]}"; do
    if [[ -z "${STACK_FILES[$stack]:-}" ]]; then
      echo "[error] Unknown stack: $stack"
      usage
      exit 1
    fi
    echo "$stack"
  done
}

./scripts/render-configs.sh
if ! docker network inspect homelab-net >/dev/null 2>&1; then
  echo "[info] Creating docker network: homelab-net"
  docker network create homelab-net >/dev/null
fi

a=()
while IFS= read -r s; do a+=("$s"); done < <(select_stacks "$@")
for stack in "${a[@]}"; do
  file="$STACK_DIR/${STACK_FILES[$stack]}"
  echo "[info] Starting stack: $stack ($file)"
  docker compose -f "$file" up -d
 done

echo "[ok] Requested stack(s) started."
