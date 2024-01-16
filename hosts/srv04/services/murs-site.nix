{ pkgs
, config
, ...
}: {
  imports = [
    ./php.nix
    ./mysql.nix
  ];

  services.nginx.virtualHosts."murs-mc.ru" = {
    forceSSL = true;
    root = "/var/www/murs-mc.ru";
    locations = { # NixOS generic PHP site config
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
    };
    extraConfig = ''
      index index.html index.htm index.php;
    '';
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
  };
}
