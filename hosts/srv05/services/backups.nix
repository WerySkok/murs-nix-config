{ pkgs
, config
, abs
, ...
}:
let
  secrets = import (abs "lib/secrets.nix");
in
{
  imports = [
    (secrets.declare [ "rustic-config" ])
  ];

  environment.systemPackages = with pkgs; [
    rustic
    rclone
  ];

  systemd.services.backups = {
    description = "Rustic backups";
    after = [ "syslog.target" "network-online.target" "run-agenix.d.mount" ];
    serviceConfig.EnvironmentFile = config.age.secrets.rustic-config.path;
    serviceConfig.Type = "oneshot";
    serviceConfig.User = "root";
    path = [ pkgs.rclone ];
    script = ''
      set -eu
      set -o pipefail
      ${pkgs.rustic}/bin/rustic backup /srv/pterodactyl --tag pterodactyl
      ${pkgs.rustic}/bin/rustic backup /var/lib/pterodactyl --tag wings
      ${pkgs.rustic}/bin/rustic backup /var/vmail --tag email
      ${pkgs.rustic}/bin/rustic backup /var/lib/mediawiki --tag mediawiki
      ${config.services.mysql.package}/bin/mysqldump --user dumper --password=dump --databases murssite phpmyadmin mediawiki | ${pkgs.rustic}/bin/rustic backup --stdin-filename database.sql - --tag database
    '';
  };
  systemd.timers.backups = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 5:00:00 Europe/Moscow";
      Persistent = true;
      Unit = "backups.service";
    };

  };

  # systemd.services.prunebackups = {
  #   description = "Prune Rustic backups";
  #   after = [ "syslog.target" "network-online.target" "run-agenix.d.mount" ];
  #   serviceConfig.EnvironmentFile = config.age.secrets.rustic-config.path;
  #   serviceConfig.Type = "oneshot";
  #   serviceConfig.User = "root";
  #   path = [pkgs.rclone];
  #   script = ''
  #     set -eu
  #     set -o pipefail
  #     ${pkgs.rustic}/bin/rustic forget --prune --keep-last 20
  #   '';
  # };

  # systemd.timers.prunebackups = {
  #   wantedBy = [ "timers.target" ];
  #   timerConfig = {
  #     OnCalendar = "Mon *-*-* 7:00:00 Europe/Moscow";
  #     Unit = "backups.service";
  #   };

  # };
}
