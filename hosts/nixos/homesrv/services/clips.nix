{
  pkgs,
  ...
}:
let
  nfsDir = "/mnt/nfs/clips";
  clipsDir = "/var/www/fi.supa.sh/clips";
in
{
  # the raw share, only rclone-clips should touch it
  fileSystems.${nfsDir} = {
    device = "10.2.0.1:/supelle";
    fsType = "nfs";
    options = [
      "async"
      "nocto"
      "noatime"
      "nosuid"
      "nodev"
      "noexec"
      "nofail"
      "noauto"
      "x-systemd.automount"
      "_netdev"
      "soft"
      "timeo=50"
      "retrans=2"
      "retry=0"
      "x-systemd.mount-timeout=15"
    ];
  };

  # caddy reads the clips as another user
  programs.fuse.userAllowOther = true;

  systemd.tmpfiles.rules = [ "d ${clipsDir} 2770 supa www -" ];

  # write-back cache on the nvme in front of the share: writes return once they're on local disk
  # and upload in the background, recently read clips are served locally
  systemd.services.rclone-clips = {
    description = "rclone write-back cache over the clips NFS share";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    unitConfig.RequiresMountsFor = nfsDir;
    path = [ "/run/wrappers" ]; # setuid fusermount3
    environment.RCLONE_CONFIG = "/dev/null";
    serviceConfig = {
      Type = "notify";
      User = "supa";
      Group = "www";
      CacheDirectory = "rclone-clips";
      ExecStart = builtins.concatStringsSep " " [
        "${pkgs.rclone}/bin/rclone mount ${nfsDir} ${clipsDir}"
        "--allow-other"
        "--umask 007"
        "--cache-dir %C/rclone-clips"
        "--vfs-cache-mode full"
        "--vfs-cache-max-size 50G"
        "--vfs-cache-max-age 48h"
        "--vfs-write-back 5s"
        "--vfs-fast-fingerprint"
        # nothing else writes to the share, so listings only change through this mount
        "--dir-cache-time 720h"
      ];
      ExecStopPost = "-/run/wrappers/bin/fusermount3 -uz ${clipsDir}";
      Restart = "on-failure";
      RestartSec = 5;
      # dirty files stay in the cache and upload on the next start, no need to wait for them
      TimeoutStopSec = 30;
    };
  };
}
