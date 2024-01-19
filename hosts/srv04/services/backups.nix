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
    rustic-rs
    rclone
  ];

  systemd.services.backups = {
    description = "Restic backups";
    after = [ "syslog.target" "network-online.target" "run-agenix.d.mount" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.EnvironmentFile = config.age.secrets.rustic-config.path;
    serviceConfig.Type = "oneshot";
    serviceConfig.User = "root";
    path = [pkgs.rclone];
    script = ''
      set -eu
      set -o pipefail
      ${pkgs.rustic-rs}/bin/rustic backup /srv/pterodactyl --tag pterodactyl
      ${pkgs.rustic-rs}/bin/rustic backup /var/lib/pterodactyl --tag wings
      ${config.services.mysql.package}/bin/mysqldump --user dumper --password=dump --databases murssite phpmyadmin | ${pkgs.rustic-rs}/bin/rustic backup --stdin-filename database.sql - --tag database
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
}
