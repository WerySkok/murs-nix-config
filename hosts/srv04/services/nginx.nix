{ pkgs, abs, config, lib, ... }@inputs:

let
  realIpsFromList = lib.strings.concatMapStringsSep "\n" (x: "set_real_ip_from  ${x};");
  fileToList = x: lib.strings.splitString "\n" (builtins.readFile x);
  cfipv4 = fileToList (pkgs.fetchurl {
    url = "https://www.cloudflare.com/ips-v4";
    sha256 = "0ywy9sg7spafi3gm9q5wb59lbiq0swvf0q3iazl0maq1pj1nsb7h";
  });
  cfipv6 = fileToList (pkgs.fetchurl {
    url = "https://www.cloudflare.com/ips-v6";
    sha256 = "1ad09hijignj6zlqvdjxv7rjj8567z357zfavv201b9vx3ikk7cy";
  });
  secrets = import (abs "lib/secrets.nix");
in
{
  imports = [
    (secrets.declare [ "cf-origin-private-cert" "cf-origin-public-cert" ])
    {
      age.secrets.cf-origin-private-cert.owner = config.services.nginx.user;
      age.secrets.cf-origin-private-cert.group = config.services.nginx.user;
      age.secrets.cf-origin-public-cert.owner = config.services.nginx.user;
      age.secrets.cf-origin-public-cert.group = config.services.nginx.user;
    }
  ];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    statusPage = true;
    enableReload = true;

    commonHttpConfig = ''
      ${realIpsFromList cfipv4}
      ${realIpsFromList cfipv6}
      real_ip_header CF-Connecting-IP;

      proxy_headers_hash_bucket_size 128;
    '';

    # default server that would reject all unmatched requests
    appendHttpConfig = ''
      server {
        listen 80 http2 default_server;
        listen 443 ssl http2 default_server;

        ssl_reject_handshake on;
        return 444;
      }
    '';

    # declared in the relevant service nixfiles
    # virtualHosts = { ... };
  };



  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
