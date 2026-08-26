{
  lib,
  ...
}:
{
  _module.args = {
    mkService = cmd: dir: packages: {
      enable = true;
      unitConfig = {
        After = "network-online.target";
      };
      serviceConfig = {
        Type = "simple";
        User = "supa";
        Restart = "always";
        RestartSec = 5;
        WorkingDirectory = dir;
        ExecStart = "/bin/sh -c ${lib.escapeShellArg (builtins.replaceStrings [ "\n" ] [ " " ] cmd)}";
        Environment = "PATH=${lib.makeBinPath packages}";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
