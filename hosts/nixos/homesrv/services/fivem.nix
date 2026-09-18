{
  ...
}:
let
  txData = "/home/fivem/artifacts/txData";

  # Both instances run out of the same artifacts directory; everything that
  # differs between them is in their env file and their txAdmin profile.
  instance =
    {
      dataDir,
      envFile,
      args ? "",
    }:
    {
      enable = true;
      restartIfChanged = false;
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        After = "network-online.target";
      };
      serviceConfig = {
        Type = "simple";
        User = "fivem";
        Restart = "always";
        RestartSec = 3;
        WorkingDirectory = "/home/fivem/artifacts";
        EnvironmentFile = envFile;
        ExecStartPre = "/bin/sh ${dataDir}/generate-env-cfg.sh";
        ExecStart = "/bin/sh run.sh${args}";
      };
    };
in
{
  systemd.services = {
    fivem = instance {
      dataDir = "${txData}/QBCoreFramework_9EAABC.base";
      envFile = "/etc/fivem.env";
    };

    fivem-staging = instance {
      dataDir = "${txData}/STAGING_QBCoreFramework_9EAABC.base";
      envFile = "/etc/fivem-staging.env";
      args = " +set serverProfile staging +set txAdminPort 40121";
    };
  };
}
