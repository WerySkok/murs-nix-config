{ pkgs, lib, config, abs, ... }:

{
  imports = [
    ../modules/mysql.nix
    ../modules/docker.nix
  ];

  virtualisation.oci-containers.containers = {
    "phpmyadmin" = {
      image = "phpmyadmin:latest";
      volumes = [
        "/run/mysqld/mysqld.sock:/tmp/mysql.sock"
      ];
      environment = {
        PMA_HOST = "localhost";
        UPLOAD_LIMIT = "1G";
        TZ = "Europe/Moscow";
      };
      ports = [ "127.0.0.1:22480:80" ];
    };
  };

  services.nginx.virtualHosts."phpmyadmin.murs-mc.ru" = {
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:22480";
    };
    enableACME = true;
  };
}
