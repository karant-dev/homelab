# Homelab

> **Note:** This is an evolving homelab. Readme might be slightly behind actual state.

## What is this?

Basic documentation for my personal homelab setup. Sections below are placeholders to organize future notes and configs.

## Hardware

- `MAIN_SERVER` - Raspberry Pi 5 8 GB

## Software & Services

This section details the software, services and stacks that comprise the homelab.

### System-level Software

Services installed directly on the host operating system.

- **Caddy:** A powerful, enterprise-ready open source web server with automatic HTTPS. It is installed system-wide and used as a reverse proxy.
  - The Caddyfile is located at `configs/Caddyfile`.
    - It's built with the Cloudflare DNS plugin for ACME DNS challenges.
- **Docker & Docker Compose:** The containerization platform used to run most of the services. The compose files are located in the `docker-compose` directory.
- **Tailscale:** Provides a secure network (a tailnet) for accessing the homelab from anywhere.

### Docker Stacks

The services are grouped into the following stacks, defined by the `docker-compose` files.

- **Arr Stack (`arr-stack.yml`):**
  - `prowlarr`: An indexer manager for torrents and usenet.
- **Media Stack (`media-stack-compose.yml`):**
  - `plex`: Media server for streaming video, music, and photos.
  - `tautulli`: A monitoring and tracking application for Plex Media Server.
  - `filebrowser`: A web-based file manager.
- **Monitoring Stack (`monitoring-stack.yml`):**
  - `homer`: A simple, static homepage for your server.
  - `glances`: A cross-platform monitoring tool.
- **Network Stack (`network-stack-compose.yml`) [not currently being used]:**
  - `npm` (Nginx Proxy Manager): A reverse proxy for managing SSL certificates and routing traffic to services.
  - `pihole`: A network-wide ad blocker.
- **Smarthome Stack (`smarthome-stack-compose.yml`):**
  - `homebridge`: A lightweight NodeJS server that emulates the iOS HomeKit API.
- **VPN & Torrenting Stack (`vpn-torr-stack-compose.yml`):**
  - `transmission-vpn`: A Transmission BitTorrent client that runs through a VPN.

### Services (Docker Containers)

Here is a list of all services running in Docker containers:

- **Filebrowser:** Web-based file manager.
- **Glances:** System monitoring tool.
- **Homebridge:** HomeKit integration for non-supported devices.
- **Homer:** Dashboard for services.
- **Plex:** Media server.
- **Prowlarr:** Indexer manager for *arr stack.
- **Tautulli:** Plex monitoring and analytics.
- **Transmission-VPN:** Torrent client with VPN.

## Setup Notes

- Caddy: installed as a system service (systemd). It reads homelab/configs/Caddyfile in this repo.
- If you need to rebuild Caddy to add plugins, use xcaddy (example above) and replace the system binary or install under a dedicated path used by your service unit.
- DNS & routing: A records have been created pointing to the homelab Tailnet IP; subdomains are pointed to their services in the Caddyfile. Caddy handles TLS dynamically via ACME/DNS (Cloudflare plugin), so certificates are managed automatically.
- Docker services: use the docker-compose files under homelab/docker-compose/. Store sensitive values (passwords, tokens, claims) outside the repository.

## Passwords & Keys

- Passwords and keys are **not** stored here.
- Recommended: store secrets in a password manager (e.g., Bitwarden) and inject into the host environment or a gitignored .env file.
- Example .env variables to set (DO NOT commit .env):
  - OPENVPN_USERNAME, OPENVPN_PASSWORD
  - PLEX_CLAIM
  - CLOUDFLARE_API_TOKEN

## To-Do

- Add backup plan
- Document security basics
- List future hardware upgrades
- Create network diagram

---

*This README will be updated regularly as devices and services are added or changed.*
