{ pkgs
, config
, ...
}: {

  services.nginx.virtualHosts."mtrwiki.murs-mc.ru" = {
    globalRedirect = "rumtr.miraheze.org";
    forceSSL = true;
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
  };
}
