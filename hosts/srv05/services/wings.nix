{ pkgs, lib, config, abs, ... }:
let
  secrets = import (abs "lib/secrets.nix");
in
{
  imports = [
    (secrets.declare [ "wings-config" ])
    (abs "modules/wings.nix")
    ./nginx.nix
  ];

  services.wings.enable = true;
  services.wings.configFile = config.age.secrets.wings-config.path;

  networking.firewall.allowedTCPPorts = [ 8080 2022 25565 ];
}
