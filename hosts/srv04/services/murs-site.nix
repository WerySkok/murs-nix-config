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
    locations."~ \\.php$".extraConfig = ''
      fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
      fastcgi_index index.php;
    '';
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
  };
}
