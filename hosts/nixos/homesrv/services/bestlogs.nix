{
  inputs,
  ...
}:
{
  imports = [
    inputs.bestlogs-rs.nixosModules.default
    {
      services.bestlogs-rs = {
        enable = true;
        restartIfChanged = false;
        environmentFile = "/etc/bestlogs.env";
        settings = {
          port = 10002;
          rateLimit = {
            enabled = true;
            events = 10;
            intervalSeconds = 10;
            trustProxy = true;
          };
          instance = {
            maintainer = "Supelle";
            message = null;
            country = "Romania";
            city = "Hunedoara";
            flag = "RO";
            url = "bestlogs.supa.codes";
          };
          umamiStats = {
            token = ""; # set in env
            id = "9615b20e-47da-47c9-a9c1-40c3b6f7b7f3";
            url = "https://intel.supa.sh";
          };
        };
      };
    }
  ];
}
