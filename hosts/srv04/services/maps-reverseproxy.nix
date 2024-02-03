{ pkgs
, config
, inputs
, abs
, ...
}:
{
  services.nginx.virtualHosts."squaremap.murs-mc.ru" = {
    # technically it's bluemap but i'm lazy to change domain
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://109.248.206.92:8123";
    };
    extraConfig = "add_header Access-Control-Allow-Origin https://murs-mc.ru;";
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
  };
  services.nginx.virtualHosts."map.murs-mc.ru" = {
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://109.248.206.92:8888";
    };
    extraConfig = "add_header Access-Control-Allow-Origin https://murs-mc.ru;";
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
  };
}
