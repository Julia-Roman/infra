{
  lib,
  pkgs,
  ...
}:
{
  systemd.services.qbittorrent = {
    enable = true;
    unitConfig = {
      After = "network-online.target";
      # the hdd mounts are nofail, so nothing else orders us after them
      RequiresMountsFor = [
        "/mnt/hdd_4t"
        "/mnt/hdd_500g"
      ];
    };
    serviceConfig = {
      Type = "exec";
      User = "qbittorrent";
      Restart = "always";
      RestartSec = 3;
      ExecStart = "${lib.getExe' pkgs.qbittorrent-nox "qbittorrent-nox"}";
      StandardError = "journal";
      StandardOutput = "journal";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
