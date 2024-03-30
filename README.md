# murs-nix-config
NixOS config for MURS

## Impure dependencies
* `/etc/ssh/agenix_key` — key for decrypting secrets.
* `/var/www/murs-mc.ru` — murs-mc.ru sources have to be downloaded separately.

## Port mapping
Opened ports:
* 22 - SSH
* 80, 443 — nginx
* 25565 — Minecraft
* 2022, 8080 — Wings daemon (users communicate with it directly)

Ports* to be proxied:
* 3000 — Planka
* 3030 — Loki
* 3031 — Promtail
* 8001 — Pterodactyl panel
* 8002 — Grafana
* 8003 — votesystem
* 9001 — Prometheus
* 22480 — phpmyadmin

*Due to a [bug](https://github.com/NixOS/nixpkgs/issues/111852), these ports have to be specified in Docker like `127.0.0.1:8000:8000`, with `127.0.0.1:` in the begining. 

## TODOs
* Cleaning up backups
* Improved config handling for RcGcDw
