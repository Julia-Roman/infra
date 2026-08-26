{
  config,
  ...
}:
{
  services.prometheus = {
    enable = true;
    port = 9001;

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };

    globalConfig.scrape_interval = "10s";
    scrapeConfigs = [
      {
        job_name = "homesrv";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
      {
        job_name = "minecraft";
        static_configs = [
          {
            targets = [ "localhost:9940" ];
            labels = {
              server_name = "mc.supa.sh";
            };
          }
        ];
      }
      {
        job_name = "logs.spanix.team";
        static_configs = [ { targets = [ "logs.spanix.team" ]; } ];
      }
      {
        job_name = "logs.supa.codes";
        static_configs = [ { targets = [ "logs.supa.codes" ]; } ];
      }
      {
        job_name = "MediaMTX";
        static_configs = [ { targets = [ "127.0.0.1:9998" ]; } ];
      }
    ];
  };
}
