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
