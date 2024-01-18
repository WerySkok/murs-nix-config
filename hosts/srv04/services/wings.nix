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
  security.acme = {
    acceptTerms = true;
    defaults.email = "weryskok@gmail.com";
  };
  users.users.nginx.extraGroups = [ "acme" ];
  services.nginx.virtualHosts."srv04.murs-mc.ru" = {
    forceSSL = true;
    enableACME = true;
  };

  services.wings.enable = true;
  services.wings.configFile = config.age.secrets.wings-config.path;

  networking.firewall.allowedTCPPorts = [ 8080 2022 ];
}
