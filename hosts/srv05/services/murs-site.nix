{ pkgs
, config
, ...
}: {
  imports = [
    ../modules/php.nix
    ../modules/mysql.nix
  ];

  services.nginx.virtualHosts."murs-mc.ru" = {
    forceSSL = true;
    enableACME = true;
    root = "/var/www/murs-mc.ru";
    locations = {
      # NixOS generic PHP site config
      "/".tryFiles = "$uri $uri/ /index.php?$query_string";
      "/favicon.ico".extraConfig = ''
        access_log off; log_not_found off;
      '';
      "/robots.txt".extraConfig = ''
        access_log off; log_not_found off;
      '';
      "~ \\.php$".extraConfig = ''
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
        fastcgi_index index.php;
      '';
      "~ /\\.(?!well-known).*".extraConfig = ''
        deny all;
      '';
      "~* composer\\.".extraConfig = ''
        deny all;
        access_log off;
        log_not_found off;
      '';
      "^~ /vendor/".extraConfig = ''
        deny all;
        access_log off;
        log_not_found off;
      '';
    };
    extraConfig = ''
      index index.html index.htm index.php;
    '';
  };
}
