{ pkgs
, abs
, inputs
, ...
}:

{
  imports = [
    (abs "hosts/nixos-common.nix")
    (abs "users/weryskok/default.nix")
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

    ./services/nginx.nix
    ./services/murs-site.nix
    ./services/phpmyadmin.nix
    ./services/mtrwiki.nix
    ./services/pterodactyl.nix
    ./services/wings.nix
    ./services/backups.nix
    ./services/mail.nix
    ./services/wiki.nix
    ./services/rcgcdw.nix
    #./services/grafana.nix
    #./services/prometheus.nix
    #./services/loki.nix
    #./services/promtail.nix
    ./services/maps-reverseproxy.nix
    #./services/votesystem.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "srv05";
  networking.domain = "murs-mc.ru";
  services.qemuGuest.enable = true;

  networking.firewall.enable = true;

}
