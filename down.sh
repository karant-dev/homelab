#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

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
  echo "Usage: ./down.sh [stack ...]"
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

a=()
while IFS= read -r s; do a+=("$s"); done < <(select_stacks "$@")
for stack in "${a[@]}"; do
  file="$STACK_DIR/${STACK_FILES[$stack]}"
  echo "[info] Stopping stack: $stack ($file)"
  docker compose -f "$file" down
 done

echo "[ok] Requested stack(s) stopped."
