{
  lib,
  pkgs,
  unstable,
  ...
}:
let
  home = "/home/supa";
  projects = "${home}/projects";
  mkService = cmd: dir: pkgs: {
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
      Environment = "PATH=${lib.makeBinPath pkgs}";
    };
    wantedBy = [ "multi-user.target" ];
  };
in
{
  systemd.services = {
    cdn-helper = mkService "./cdn-helper" "${projects}/cdn-helper" [ pkgs.ffmpeg-full ];
    supa8 = mkService "./supa8" "${projects}/supa8" [
      pkgs.git
      pkgs.zbar
      pkgs.ffmpeg-full
      pkgs.yt-dlp-git
    ];
    whatbot = mkService "./whatbot" "${projects}/whatbot" [ ];
    twitch-clipper = mkService "./twitch-clipper" "${projects}/twitch-clipper" [ pkgs.ffmpeg-full ];
    srt-stream-receiver = mkService "./srt-stream-receiver" "${projects}/srt-stream-receiver" [ ];

    twitch-tags = mkService "node ." "${projects}/twitch-tags" [ pkgs.nodejs ];
    # supatv-api = mkService "./api" "${projects}/supatv/api" [ ];

    rustlog = mkService "./rustlog" "${home}/git/rustlog" [ ];

    umami = mkService "PORT=1700 node .next/standalone/server.js" "${home}/git/umami" [
      pkgs.nodejs_22
    ];

    mediamtx = mkService "./mediamtx" "${home}/git/mediamtx" [ pkgs.ffmpeg-full ];

    spacetimedb =
      mkService "./spacetime start --listen-addr 0.0.0.0:12661" "${home}/git/SpacetimeDB/target/release"
        [ ];

    mc-supa = {
      enable = true;
      restartIfChanged = false;
      unitConfig = {
        After = "network-online.target";
      };
      serviceConfig = {
        Type = "simple";
        User = "minecraft";
        Restart = "always";
        RestartSec = 3;
        WorkingDirectory = "/home/minecraft/supa";
        ExecStart = lib.escapeShellArgs [
          (lib.getExe' pkgs.jdk21 "java")
          "-Xms2G"
          "-Xmx12G"
          "-XX:+AlwaysPreTouch"
          "-XX:+DisableExplicitGC"
          "-XX:+ParallelRefProcEnabled"
          "-XX:+PerfDisableSharedMem"
          "-XX:+UnlockExperimentalVMOptions"
          "-XX:+UseG1GC"
          "-XX:G1HeapRegionSize=8M"
          "-XX:G1HeapWastePercent=5"
          "-XX:G1MaxNewSizePercent=40"
          "-XX:G1MixedGCCountTarget=4"
          "-XX:G1MixedGCLiveThresholdPercent=90"
          "-XX:G1NewSizePercent=30"
          "-XX:G1RSetUpdatingPauseTimePercent=5"
          "-XX:G1ReservePercent=20"
          "-XX:InitiatingHeapOccupancyPercent=15"
          "-XX:MaxGCPauseMillis=200"
          "-XX:MaxTenuringThreshold=1"
          "-XX:SurvivorRatio=32"
          "-Djava.library.path=${lib.makeLibraryPath [ pkgs.udev ]}"
          "-jar"
          "paper.jar"
          "nogui"
        ];
      };
      wantedBy = [ "multi-user.target" ];
    };

    fivem = {
      enable = false;
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

    qbittorrent = {
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

    vnstati = {
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
  };

  systemd.timers = {
    vnstati = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "30m";
        OnUnitActiveSec = "30m";
        Unit = "vnstati.service";
      };
    };
  };
}
