{
  lib,
  pkgs,
  ...
}:
{
  systemd.services.mc-supa = {
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
      MemoryMax = "6G";
      MemorySwapMax = "2G";
      WorkingDirectory = "/home/minecraft/supa";
      ExecStart = lib.escapeShellArgs [
        (lib.getExe' pkgs.jdk21 "java")
        "-Xms512M"
        "-Xmx4G"
        # The server sits empty most of the time; an idle G1 only returns
        # heap to the OS after a GC cycle, which this forces every 5 minutes.
        "-XX:G1PeriodicGCInterval=300000"
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
}
