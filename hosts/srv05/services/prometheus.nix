{ config, ... }: {
  services.prometheus = {
    enable = true;
    port = 9001;

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
      nginx = {
        enable = true;
        port = 9113;
      };
    };

    scrapeConfigs = [
      {
        job_name = "srv05_node";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
      {
        job_name = "srv05_nginx";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.nginx.port}" ];
        }];
      }
      {
        job_name = "murs_minecraft";
        static_configs = [{
          targets = [ "172.18.0.1:25585" ];
        }];
      }
    ];
  };
  services.nginx.statusPage = true;
}
