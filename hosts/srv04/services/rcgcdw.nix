{ pkgs
, config
, abs
, ...
}:
let
  secrets = import (abs "lib/secrets.nix");
  python = pkgs.python3.withPackages (ps: with ps; [
    beautifulsoup4
    requests
    lxml
  ]);
  rcgcdw = fetchGit {
    url = "https://gitlab.com/weryskok/RcGcDw.git";
    ref = "master";
    rev = "b14e4bf3e3f1951c76059c2f468fbc414853efd9";
  };
in
{
  imports = [
    (secrets.declare [ "rcgcdw-murswiki" "rcgcdw-mtrwiki" ])
  ];

  environment.systemPackages = with pkgs; [
    rustic-rs
    rclone
  ];

  systemd.services = {
    "rcgcdw@" = {
      description = "RcGcDw for %i";
      after = [ "syslog.target" "network-online.target" "run-agenix.d.mount" ];
      serviceConfig = {
        Type = "simple";
        User = "root";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
    "rcgcdw@murswiki" = {
      overrideStrategy = "asDropin";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${python}/bin/python3 ${rcgcdw}/start.py --settings ${config.age.secrets.rcgcdw-murswiki.path}";
        WorkingDirectory = rcgcdw;
      };
    };
    "rcgcdw@mtrwiki" = {
      overrideStrategy = "asDropin";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${python}/bin/python3 ${rcgcdw}/start.py --settings ${config.age.secrets.rcgcdw-mtrwiki.path}";
        WorkingDirectory = rcgcdw;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/rcgcdw 0755 root root"
    "d /srv/rcgcdw/murswiki 0755 root root"
    "d /srv/rcgcdw/mtrwiki 0755 root root"
  ];
}
