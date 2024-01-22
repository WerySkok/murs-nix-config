{ config, pkgs, ... }: {
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "grafana.murs-mc.ru";
      http_port = 8002;
      http_addr = "127.0.0.1";
    };
  };

  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
    forceSSL = true;
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
  };
}
