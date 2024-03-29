{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [ php ];

  services.phpfpm.pools.mypool = {
    user = "nobody";
    settings = {
      "pm" = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 32;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
      "pm.max_requests" = 500;
    };
  };
}
