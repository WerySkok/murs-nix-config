{ pkgs
, config
, abs
, inputs
, ...
}:
let
  secrets = import (abs "lib/secrets.nix");
in
{
  imports =
    [
      # { disabledModules = [ "services/mail/dovecot.nix" ]; }
      (secrets.declare [ "weryskok-at-murs-mc.ru" "noreply-at-murs-mc.ru" ])
    ];

  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "srv05.murs-mc.ru";
    domains = [ "murs-mc.ru" ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "weryskok@murs-mc.ru" = {
        hashedPasswordFile = config.age.secrets."weryskok-at-murs-mc.ru".path;
        aliases = [ "postmaster@murs-mc.ru" "abuse@murs-mc.ru" ];
      };
      "noreply@murs-mc.ru" = {
        hashedPasswordFile = config.age.secrets."noreply-at-murs-mc.ru".path;
      };
    };
    certificateScheme = "acme-nginx";
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "weryskok@gmail.com";
  };
}
