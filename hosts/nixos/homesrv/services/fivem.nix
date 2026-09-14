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
      EnvironmentFile = "/etc/fivem.env";
      ExecStartPre = "/bin/sh /home/fivem/artifacts/txData/QBCoreFramework_9EAABC.base/generate-env-cfg.sh";
      ExecStart = "/bin/sh run.sh";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
