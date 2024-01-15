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
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "srv04";
  networking.domain = "murs-mc.ru";
  services.qemuGuest.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ ''ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAwp9q2hM4ECz7mkPTnmAJ4oV2JYAST945sNSy6GZNU3fsq6aSeanlRcJb8s1lqtGi3x+d3TKihHI9MZh0R2FO0Y5B5XrCEAo+bM9HRktStnRHwmVNM0E7PTW+xFTcdARUBR7ZBu5ylwOHMtq3qSTx1u7mnVpsbRiUJl9bir/oh2YfhQRlA9xxw/o79+PqhSyt15d5qiYw4P1DK8Ak/tlzRzZGoqRnroCpzIZKZPrIfVr4K4JlwVHTuacz6CNlzsCxz/NkHvgIVJpWPZeXl04hnQoMM2CqBfPcKtADl17p4hArHe+ProYVpd8/XEDNQmAI4YkmVfbC2AFUxs0n0V2DwQ=='' ];
  networking.firewall.enable = false;
}
