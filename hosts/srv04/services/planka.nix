{ pkgs
, config
, inputs
, abs
, ...
}:
let
  secrets = import (abs "lib/secrets.nix");
in
{
  imports = [
    ../modules/arion.nix
    (secrets.declare [ "planka-config" ])
  ];
  # based on https://github.com/plankanban/planka/blob/0c1c7e2192e86e29c0042f97e1792692e59f95b8/docker-compose.yml
  virtualisation.arion.projects.planka = {
    settings = {
      services = {
        planka.service = {
          image = "ghcr.io/plankanban/planka:latest";
          command = ''
            bash -c
              "for i in `seq 1 30`; do
                ./start.sh &&
                s=$$? && break || s=$$?;
                echo \"Tried $$i times. Waiting 5 seconds...\";
                sleep 5;
              done; (exit $$s)"
          '';
          restart = "unless-stopped";
          ports = [
            "127.0.0.1:3000:1337"
          ];
          volumes = [
            "/srv/planka/user-avatars:/app/public/user-avatars"
            "/srv/planka/project-background-images:/app/public/project-background-images"
            "/srv/planka/attachments:/app/private/attachments"
          ];

          env_file = [ config.age.secrets.planka-config.path ];

          environment = {
            BASE_URL = "https://planka.murs-mc.ru";
            DATABASE_URL = "postgresql://postgres@postgres/planka";
            DEFAULT_ADMIN_EMAIL = "weryskok@gmail.com"; # Do not remove if you want to prevent this user from being edited/deleted6
            DEFAULT_ADMIN_NAME = "Александр Минкин";
            DEFAULT_ADMIN_USERNAME = "WerySkok";
          };
          depends_on = [ "postgres" ];
        };
        postgres.service = {
          image = "postgres:14-alpine";
          restart = "unless-stopped";
          volumes = [
            "/srv/planka/db-data:/var/lib/postgresql/data"
          ];

          environment = {
            POSTGRES_DB = "planka";
            POSTGRES_HOST_AUTH_METHOD = "trust";
          };
        };
      };
    };
  };

  services.nginx.virtualHosts."planka.murs-mc.ru" = {
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
    };
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
  };

  # Create paths if they do not exist, user & group are subject to the discussion
  systemd.tmpfiles.rules = [
    "d /srv/planka 0755 root root"
    "d /srv/planka/user-avatars 0755 root root"
    "d /srv/planka/project-background-images 0755 root root"
    "d /srv/planka/attachments 0755 root root"
    "d /srv/planka/db-data 0755 root root"
  ];
}
