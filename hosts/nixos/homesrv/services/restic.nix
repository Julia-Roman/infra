{
  ...
}:
{
  services.restic = {
    backups.digi = {
      initialize = true;
      repository = "rclone:digi:backups/homesrv/";
      passwordFile = "/root/.secrets/RESTIC_PASSWORD_FILE";
      timerConfig = {
        OnCalendar = "03:00";
        RandomizedDelaySec = "30m";
        Persistent = true;
      };
      exclude = [
        "node_modules"
        "/home/*/go"
        ".cache"
        ".cargo"
        ".rustup"
        "/var/cache"
        "/var/www/fi.supa.sh"
        "/var/www/i.supa.sh"
        "/var/lib/jellyfin/transcodes"
        "/home/minecraft/**/bluemap/web/maps"
        "/home/fivem/**/cache"
      ];
      paths = [
        "/root"
        "/home"
        "/var/www"
        "/var/lib"
        "/etc"
      ];
      pruneOpts = [
        "--keep-daily=7"
        "--keep-weekly=6"
        "--keep-monthly=5"
      ];
    };
  };
}
