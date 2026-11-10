{
  lib,
  pkgs,
  ...
}:
let
  nfsDir = "/mnt/nfs/clips";
  # new clips land here and stay until they're safely on the share, so writes never wait on the network
  hotDir = "/var/lib/clips/hot";
  # rclone read cache over the share
  coldDir = "/var/lib/clips/cold";
  clipsDir = "/var/www/fi.supa.sh/clips";

  rclone = lib.getExe pkgs.rclone;
  findmnt = lib.getExe' pkgs.util-linux "findmnt";

  # the automount answers even when the server is down, so look for the real nfs mount behind it
  nfsUp = pkgs.writeShellScript "clips-nfs-up" ''
    ls ${nfsDir} >/dev/null && ${findmnt} -t nfs4 ${nfsDir} >/dev/null
  '';
in
{
  # the raw share, only rclone-clips and clips-upload should touch it
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

  # what caddy and twitch-clipper see: hot first, then the share, new files always go to hot
  fileSystems.${clipsDir} = {
    device = "${hotDir}=RW:${coldDir}=NC";
    fsType = "fuse.mergerfs";
    noCheck = true;
    options = [
      "allow_other"
      "category.create=ff"
      "fsname=clips"
      "nofail"
    ];
  };
  system.fsPackages = [ pkgs.mergerfs ];

  # caddy reads the clips as another user
  programs.fuse.userAllowOther = true;

  systemd.tmpfiles.rules = [
    "d /var/lib/clips 2750 supa www -"
    "d ${hotDir} 2770 supa www -"
    "d ${coldDir} 2770 supa www -"
  ];

  systemd.services.rclone-clips = {
    description = "rclone read cache over the clips NFS share";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    # keep retrying while the share is down, until then mergerfs serves only the hot clips
    startLimitIntervalSec = 0;
    path = [ "/run/wrappers" ]; # setuid fusermount3
    environment.RCLONE_CONFIG = "/dev/null";
    serviceConfig = {
      Type = "notify";
      User = "supa";
      Group = "www";
      CacheDirectory = "rclone-clips";
      ExecStartPre = nfsUp;
      ExecStart = builtins.concatStringsSep " " [
        "${rclone} mount ${nfsDir} ${coldDir}"
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
      ExecStopPost = "-/run/wrappers/bin/fusermount3 -uz ${coldDir}";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 30;
    };
  };

  # pushes new clips to the share and drops hot copies the share already has
  systemd.services.clips-upload = {
    description = "Upload new clips to the NFS share";
    environment.RCLONE_CONFIG = "/dev/null";
    serviceConfig = {
      Type = "oneshot";
      User = "supa";
      Group = "www";
    };
    script = ''
      ${nfsUp}
      # never write into the bare directory under an unmounted cache
      ${findmnt} -t fuse.rclone ${coldDir} >/dev/null

      # through the cache so its listings see them; skip files that are still being written
      ${rclone} copy ${hotDir} ${coldDir} --min-age 1m
      # straight against the share: only deletes a hot copy once it's identical there
      ${rclone} move ${hotDir} ${nfsDir} --min-age 48h
    '';
  };

  systemd.timers.clips-upload = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitInactiveSec = "1m";
    };
  };
}
