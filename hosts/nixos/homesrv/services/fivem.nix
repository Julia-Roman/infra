{
  ...
}:
{
  systemd.services.fivem = {
    enable = true;
    restartIfChanged = false;
    unitConfig = {
      After = "network-online.target";
    };
    serviceConfig = {
      Type = "simple";
      User = "fivem";
      Restart = "always";
      RestartSec = 3;
      WorkingDirectory = "/home/fivem/artifacts";
      ExecStart = "/bin/sh run.sh";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
