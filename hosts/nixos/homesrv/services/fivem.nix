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
    fivem =
      instance {
        dataDir = "${txData}/QBCoreFramework_9EAABC.base";
        envFile = "/etc/fivem.env";
      }
      // {
        wantedBy = [ "multi-user.target" ];
      };

    # Not wanted by multi-user.target: a Cfx license key only works on one
    # running server at a time, so this stays a `systemctl start fivem-staging`
    # until /etc/fivem-staging.env has a key of its own.
    fivem-staging = instance {
      dataDir = "${txData}/STAGING_QBCoreFramework_9EAABC.base";
      envFile = "/etc/fivem-staging.env";
      args = " +set serverProfile staging +set txAdminPort 40121";
    };
  };
}
