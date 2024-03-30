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
    (secrets.declare [ "votesystem-config" ])
  ];

  virtualisation.oci-containers.containers = {
    "votesystem" = {
      image = "ghcr.io/weryskok/votesystem-csharp:1.0";
      volumes = [
        "${config.age.secrets.votesystem-config.path}:/app/config.json"
        "/srv/votesystem/database:/app/database"
      ];
      ports = [ "127.0.0.1:8003:80" ];
      environment = {
        TZ = "Europe/Moscow";
        ASPNETCORE_FORWARDEDHEADERS_ENABLED = "true";
      };
    };
  };

  services.nginx.virtualHosts."vote.murs-mc.ru" = {
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8003";
      recommendedProxySettings = true;
      # extraConfig = ''
      # proxy_http_version 1.1;
      # proxy_set_header   Upgrade $http_upgrade;
      # proxy_set_header   Connection $connection_upgrade;
      # proxy_set_header   Host $host;
      # proxy_cache_bypass $http_upgrade;
      # proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      # proxy_set_header   X-Forwarded-Proto $scheme;
      # '';
    };
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
  };

  # Create paths if they do not exist, user & group are subject to the discussion
  systemd.tmpfiles.rules = [
    "d /srv/votesystem 0755 root root"
    "d /srv/votesystem/database 0755 root root"
  ];
}

