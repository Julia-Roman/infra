{
  mkService,
  pkgs,
  ...
}:
{
  systemd.services.supa8 = mkService "./supa8" "/home/supa/projects/supa8" [
    pkgs.git
    pkgs.zbar
    pkgs.ffmpeg-full
    pkgs.yt-dlp-git
  ];
}
