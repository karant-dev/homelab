# Homelab

> **Note:** This is an evolving homelab. Readme might be slightly behind actual state.

## What is this?

Basic documentation for my personal homelab setup. Sections below are placeholders to organize future notes and configs.

## Hardware

- `MAIN_SERVER` - Raspberry Pi 5 8 GB

## Software & Services

- `CADDY` - installed system-wide (systemd), not as a Docker container.
  - Built with xcaddy to include the Cloudflare DNS plugin for ACME DNS challenges:
    - Example build command: xcaddy build --with github.com/caddy-dns/cloudflare
  - Caddyfile in this repo: homelab/configs/Caddyfile
  - Environment variables used by Caddy and DNS plugins:
    - CLOUDFLARE_API_TOKEN — Cloudflare API token for DNS challenge
  - Do NOT commit tokens/emails. Use a gitignored .env or set system environment variables.
- `TAILSCALE` / Tailnet — this system is joined to my Tailnet, providing private, secure access to the homelab when off the home Wi‑Fi network. A records have been created in Cloudflare pointing to the homelab's Tailnet IP, and subdomains are routed to their respective services.
- `DOCKER` / Docker Compose — most services run as containers (see docker-compose/*.yml)
- `PLEX_MEDIA_SERVER` - *deployed via Docker Compose*

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
