# Homelab One-Command Template

Reusable Docker-based homelab template for Debian/Ubuntu hosts.

## Quick start

```bash
git clone https://github.com/<your-user>/homelab.git
cd homelab
cp .env.example .env
# edit .env with your domain + secrets
./install.sh
./up.sh
```

Start only selected stacks:

```bash
./up.sh admin media dev
```

Stop all or selected stacks:

```bash
./down.sh
./down.sh media arr
```

## Repository layout

```text
.
├── configs/
│   ├── Caddyfile
│   ├── Caddyfile.template
│   ├── homer.yml
│   └── homer.yml.template
├── docker-compose/
│   ├── admin-stack.yml
│   ├── ai-stack.yml
│   ├── arr-stack.yml
│   ├── dev-stack.yml
│   ├── home-stack.yml
│   ├── media-stack.yml
│   ├── productivity-stack.yml
│   └── smarthome-stack.yml
├── scripts/
│   └── render-configs.sh
├── .env.example
├── install.sh
├── up.sh
└── down.sh
```

## Architecture (brief)

- Host-level components: Docker Engine, Docker Compose plugin, Caddy, Tailscale.
- App components: grouped in independent Docker Compose stacks under `docker-compose/`.
- Shared configuration: `.env` + runtime templating (`envsubst`) for Caddy + Homer configs.
- Orchestration: `up.sh` and `down.sh` can run all stacks or a selected subset.

## Compose strategy and tradeoff

This repository keeps **multiple compose files + orchestration scripts**.

Why this approach:
- Easier to operate partial workloads (`./up.sh media dev`) without editing files.
- Lower blast radius: one stack can be changed/restarted independently.
- Better readability for homelab users than one very large compose file.

Tradeoff:
- Cross-stack dependencies are managed operationally (script order) instead of in one Compose model.

## Configuration guide (`.env`)

Required core values:
- `DOMAIN` → base domain (example: `example.com`)
- `DATA_ROOT` → persistent app data root
- `MEDIA_ROOT` → media mount root
- `CLOUDFLARE_API_TOKEN` → for Caddy DNS challenge
- `CLOUDFLARE_TUNNEL_TOKEN` → for cloudflared container
- `TAILSCALE_AUTH_KEY` → host Tailscale bootstrap key (kept for setup docs/workflow)

After editing `.env`, render config templates manually if needed:

```bash
./scripts/render-configs.sh
```

Generated outputs:
- `configs/Caddyfile`
- `configs/homer/config.yml` (and mirrored to `configs/homer.yml` for convenience)

## Install flow (`install.sh`)

`install.sh` is idempotent and safe to re-run. It will:

1. Install prerequisites (`curl`, `gnupg`, `gettext-base`, etc.).
2. Install Docker Engine + Compose plugin if missing.
3. Enable/start Docker service.
4. Create required directories from `.env` paths.
5. Add current user to `docker` group (if needed).
6. Run light sanity checks (free disk + ports 80/443 in use).
7. Render templated configs.

## Known limitations

- This is a homelab template, not a hardened production baseline.
- Secrets are environment-based; do not commit real tokens in `.env`.
- Some services require manual post-setup API keys/tokens in app UIs.
- VPN-dependent workloads (arr stack) depend on valid provider credentials.
- Host-level Caddy/Tailscale installation details vary by distro and are minimally opinionated here.
- Port collisions are possible if the host already runs other services.

## Notes

- Compose files use `.env` interpolation for paths/domain/secrets.
- If you change `DOMAIN`, re-run `./scripts/render-configs.sh` and reload Caddy.
