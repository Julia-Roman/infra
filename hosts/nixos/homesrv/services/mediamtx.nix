{
  mkService,
  pkgs,
  ...
}:
{
  systemd.services.mediamtx = mkService "./mediamtx" "/home/supa/git/mediamtx" [ pkgs.ffmpeg-full ];
}
