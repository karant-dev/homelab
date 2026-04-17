# Homelab

> **Note:** This is an evolving homelab. Readme might be slightly behind actual state.

## What is this?

Basic documentation for my personal homelab setup. Sections below organize notes and configs.

## Hardware

- `MAIN_SERVER` - Bosgame M4 (Ryzen 7 6800H, 32GB DDR5 RAM, 1TB SSD)
- `STORAGE` - 16TB Seagate External HDD

## Software & Services

This section details the software, services and stacks that comprise the homelab.

### System-level Software

Services installed directly on the host operating system.

- **Caddy:** Web server with automatic HTTPS. Installed system-wide as reverse proxy. Handles routing for many internal ports.
  - Caddyfile located at `configs/Caddyfile`.
  - Built with Cloudflare DNS plugin for ACME DNS challenges.
- **Docker & Docker Compose:** Containerization platform. Compose files located in `docker-compose` directory.
- **Tailscale:** Secure network (tailnet) for accessing homelab remotely.

### Docker Stacks & Containers

Services grouped by Docker Compose stack based on container labels.

- **admin-stack (`admin-stack.yml`):**
  - `autohealer`: Automated container restart utility.
  - `cloudflared`: Cloudflare tunnel daemon.
  - `dockerproxy`: Secure Docker socket proxy.
  - `glances`: System monitoring tool.
  - `homer`: Static dashboard for services.
  - `watchtower`: Automated container image updates.
  - `wud`: Container update notifier.

- **ai-stack (`ai-stack.yml`):**
  - `ollama`: Local large language model runner.
  - `open-webui`: Web interface for local LLMs.

- **arr-stack (`arr-stack.yml`):**
  - `bazarr`: Subtitle manager.
  - `bookshelf`: Book tracking and management.
  - `flaresolverr`: Captcha bypass proxy.
  - `gluetun`: VPN client for secure network routing.
  - `lidarr`: Music collection manager.
  - `profilarr`: Radarr/Sonarr profile sync.
  - `prowlarr`: Indexer manager.
  - `qbittorrent`: Torrent client.
  - `radarr`: Movie collection manager.
  - `seerr`: Media request management.
  - `sonarr`: TV show collection manager.

- **dev-stack (`dev-stack.yml`):**
  - `code-server`: Web-based VS Code environment.
  - `ittools`: Collection of handy tools for developers.
  - `n8n`: Workflow automation platform.
  - `network-tools`: Networking troubleshooting toolbox.

- **home-stack (`home-stack.yml`):**
  - `actual-server`: Local personal finance management.
  - `mealie`: Recipe and meal management.

- **media-stack (`media-stack.yml`):**
  - `audiobookshelf`: Audiobook and podcast server.
  - `copyparty`: Web-based file manager and sharing.
  - `filebrowser`: Web-based file manager.
  - `iSponsorBlockTV`: SponsorBlock implementation for TV apps.
  - `jellyfin`: Media server.
  - `jellyplex-watched`: Sync watched status.
  - `metube`: YouTube downloader.
  - `musicgrabber`: Music downloading tool.
  - `navidrome`: Music server.
  - `plex`: Media server for streaming video.
  - `romm`: Retro game ROM manager.
  - `tautulli`: Media monitoring and analytics.
  - `tracearr`: New app for media monitoring, supports Plex + Jellyfin + Emby.

- **productivity-stack (`productivity-stack.yml`):**
  - `beaverhabits`: Habit tracking application.
  - `bentopdf`: PDF manipulation and editing tool.
  - `karakeep`: Data management application.
  - `karakeep-chrome`: Chrome dependency for karakeep.
  - `karakeep-meilisearch`: Search dependency for karakeep.
  - `memos`: Privacy-first lightweight note-taking service.

- **smarthome-stack (`smarthome-stack.yml`):**
  - `homebridge`: HomeKit integration for non-supported devices.

- **Standalone Containers (No Stack):**
  - `portainer`: Container management GUI.

## Setup Notes

- Caddy: installed as a system service (systemd). It reads `configs/Caddyfile` in this repo.
- DNS & routing: A records point to homelab Tailnet IP; subdomains point to services in Caddyfile. Caddy handles TLS dynamically via ACME/DNS (Cloudflare).
- Docker services: use docker-compose files under `docker-compose/`. Store sensitive values outside repository.

## Passwords & Keys

- Passwords and keys are **not** stored here.
- Recommended: store secrets in a password manager (e.g., Bitwarden) and inject into host environment.
- Example secrets (DO NOT commit):
  - CLOUDFLARE_API_TOKEN

## To-Do

- Add backup plan
- Document security basics
- List future hardware upgrades
- Create network diagram
