{ config, pkgs, ... }: {
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "grafana.murs-mc.ru";
      http_port = 8002;
      http_addr = "127.0.0.1";
    };
    settings.security.secret_key = "SW2YcwTIb9zpOOhoPsMm"; # 
  };

  services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
    };
    forceSSL = true;
    enableACME = true;
  };
}
