{
  lib,
  pkgs,
  ...
}:
{
  systemd.services.vnstati = {
    script = ''
      ${lib.getExe' pkgs.vnstat "vnstati"} -vs -L --headertext "bandwidth (UTC)" -o /var/www/fi.supa.sh/sys/vnstat.png
    '';
    unitConfig = {
      After = "network-online.target";
    };
    serviceConfig = {
      Type = "oneshot";
      User = "supa";
    };
  };

  systemd.timers.vnstati = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "30m";
      OnUnitActiveSec = "30m";
      Unit = "vnstati.service";
    };
  };
}
