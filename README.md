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

Ports to be proxied:
* 8001 — Pterodactyl panel
* 22480 — phpmyadmin

## TODOs
* Cleaning up backups
* Forum maybe?
* Prometheus and Graphana (analytics)
* RcGcDw
