{ pkgs
, config
, inputs
, abs
, ...
}:
let
  secrets = import (abs "lib/secrets.nix");
  database = {
    MYSQL_PASSWORD = "Ky^Ydy9TSH5dzpt3"; # i'm not sure it'd be useful in case of leak
    MYSQL_ROOT_PASSWORD = "Ky^Ydy9TSH5dzpt3";
  };
  panel = {
    APP_URL = "https://panel.murs-mc.ru";
    APP_TIMEZONE = "Europe/Moscow";
    APP_SERVICE_AUTHOR = "weryskok@gmail.com";
  };
  mail = {
    MAIL_FROM = "noreply+panel@murs-mc.ru"; 
    MAIL_DRIVER = "smtp";
    MAIL_HOST = "srv04.murs-mc.ru";
    MAIL_PORT = "465";
    MAIL_USERNAME = "noreply@murs-mc.ru";
    #MAIL_PASSWORD = ""; declared secretly
    MAIL_ENCRYPTION = "true";
  };
in
{
  imports = [
    ../modules/arion.nix
    (secrets.declare [ "pterodactyl-config" ])
  ];
  # based on https://github.com/pterodactyl/panel/blob/fe83a4f7552dd7ffe5a8455d09d42c443e6b3e91/docker-compose.example.yml
  virtualisation.arion.projects.pterodactyl = {
    settings = {
      services = {
        database.service = {
          image = "mariadb:10.5";
          restart = "always";
          command = "--default-authentication-plugin=mysql_native_password";
          volumes = [ "/srv/pterodactyl/database:/var/lib/mysql" ];
          environment = {
            inherit (database) MYSQL_PASSWORD MYSQL_ROOT_PASSWORD;
            MYSQL_DATABASE = "panel";
            MYSQL_USER = "pterodactyl";
          };
        };

        cache.service = {
          image = "redis:alpine";
          restart = "always";
        };

        panel.service = {
          image = "ghcr.io/pterodactyl/panel:latest";
          restart = "always";
          ports = [
            "127.0.0.1:8001:80"
          ];
          links = [ "database" "cache" ];
          volumes = [
            "/srv/pterodactyl/var/:/app/var/"
            "/srv/pterodactyl/nginx/:/etc/nginx/http.d/"
            "/srv/pterodactyl/certs/:/etc/letsencrypt/"
            "/srv/pterodactyl/logs/:/app/storage/logs"
          ];

          env_file = [config.age.secrets.wings-config.path];

          environment = {
            inherit (panel) APP_URL APP_TIMEZONE APP_SERVICE_AUTHOR;
            inherit (mail) MAIL_FROM MAIL_DRIVER MAIL_HOST MAIL_PORT MAIL_USERNAME MAIL_ENCRYPTION;
            DB_PASSWORD = database.MYSQL_PASSWORD;
            APP_ENV = "production";
            APP_ENVIRONMENT_ONLY = "false";
            CACHE_DRIVER = "redis";
            SESSION_DRIVER = "redis";
            QUEUE_DRIVER = "redis";
            REDIS_HOST = "cache";
            DB_HOST = "database";
            DB_PORT = "3306";
          };
        };
      };
      networks.default.ipam.config = [{ subnet = "172.20.0.0/16"; }];
    };
  };

  services.nginx.virtualHosts."panel.murs-mc.ru" = {
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8001";
    };
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
  };

  # Create paths if they do not exist, user & group are subject to the discussion
  systemd.tmpfiles.rules = [
    "d /srv/pterodactyl 0755 root root"
    "d /srv/pterodactyl/database 0755 root root"
    "d /srv/pterodactyl/var 0755 root root"
    "d /srv/pterodactyl/nginx 0755 root root"
    "d /srv/pterodactyl/certs 0755 root root"
    "d /srv/pterodactyl/logs 0755 root root"
  ];
}
