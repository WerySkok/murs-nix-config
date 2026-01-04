{ pkgs
, config
, ...
}: {

  services.nginx.virtualHosts."mtrwiki.murs-mc.ru" = {
    globalRedirect = "rumtr.miraheze.org";
    forceSSL = true;
    enableACME = true;
  };
}
