#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [[ ! -f .env ]]; then
  if [[ -f .env.example ]]; then
    cp .env.example .env
    echo "[info] Created .env from .env.example. Update secrets before running up.sh."
  else
    echo "[error] .env.example is missing."
    exit 1
  fi
fi

# shellcheck disable=SC1091
source .env

require_sudo() {
  if [[ "${EUID}" -ne 0 ]]; then
    SUDO="sudo"
  else
    SUDO=""
  fi
}

require_sudo

install_prereqs() {
  $SUDO apt-get update -y
  $SUDO apt-get install -y ca-certificates curl gnupg lsb-release gettext-base
}

install_docker() {
  if command -v docker >/dev/null 2>&1; then
    echo "[info] Docker already installed."
    return
  fi

  echo "[info] Installing Docker Engine and Compose plugin..."
  $SUDO install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/$(. /etc/os-release && echo "$ID")/gpg | $SUDO gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  $SUDO chmod a+r /etc/apt/keyrings/docker.gpg

  CODENAME="$(. /etc/os-release && echo "${VERSION_CODENAME}")"
  ARCH="$(dpkg --print-architecture)"
  echo \
    "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release && echo "$ID") ${CODENAME} stable" \
    | $SUDO tee /etc/apt/sources.list.d/docker.list >/dev/null

  $SUDO apt-get update -y
  $SUDO apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

start_docker() {
  $SUDO systemctl enable docker
  $SUDO systemctl start docker
}

create_directories() {
  echo "[info] Creating directories..."
  mkdir -p "$DATA_ROOT" "$MEDIA_ROOT" "$CONFIG_ROOT/homer"
  mkdir -p "$DATA_ROOT"/{arr,code-server,copyparty,homer,ittools,jellyfin,karakeep,mealie,memos,metube,n8n,ollama,open-webui,plex,tautulli,tracearr}
}

sanity_checks() {
  local available_gb
  available_gb=$(df -BG "$DATA_ROOT" | awk 'NR==2{gsub("G","",$4); print $4}')
  if [[ -n "${available_gb:-}" && "$available_gb" -lt 20 ]]; then
    echo "[warn] Less than 20GB free at DATA_ROOT ($DATA_ROOT)."
  fi

  local ports=(80 443)
  for p in "${ports[@]}"; do
    if ss -lnt "( sport = :$p )" | tail -n +2 | grep -q .; then
      echo "[warn] Port $p already in use."
    fi
  done
}

add_user_to_docker_group() {
  if id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
    echo "[info] User '$USER' already in docker group."
    return
  fi

  echo "[info] Adding '$USER' to docker group..."
  $SUDO usermod -aG docker "$USER"
  echo "[warn] Log out and back in (or run: newgrp docker) to use Docker without sudo."
}

main() {
  if [[ -f /etc/debian_version ]]; then
    install_prereqs
    install_docker
    start_docker
  else
    echo "[error] This installer currently supports Debian/Ubuntu hosts."
    exit 1
  fi

  create_directories
  sanity_checks
  add_user_to_docker_group

  if ! docker network inspect homelab-net >/dev/null 2>&1; then
    docker network create homelab-net >/dev/null
  fi

  ./scripts/render-configs.sh

  echo "[ok] Install complete."
  echo "[next] 1) Edit .env secrets"
  echo "[next] 2) Run ./up.sh"
}

main "$@"
