{ pkgs
, config
, inputs
, abs
, ...
}:
{
  services.nginx.virtualHosts."bluemap.murs-mc.ru" = {
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://178.130.53.4:8123";
    };
    extraConfig = "add_header Access-Control-Allow-Origin https://murs-mc.ru;";
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
  };
  services.nginx.virtualHosts."map.murs-mc.ru" = {
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://178.130.53.4:8888";
    };
    extraConfig = "add_header Access-Control-Allow-Origin https://murs-mc.ru;";
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
  };
}
