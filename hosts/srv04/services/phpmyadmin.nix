{ pkgs, lib, config, abs, ... }:

{
  imports = [
    ./mysql.nix
  ];

  virtualisation.docker.enable = true;
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
      ports = [ "22480:80" ];
    };
  };

  services.nginx.virtualHosts."phpmyadmin.murs-mc.ru" = {
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:22480";
    };
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
  };
}
