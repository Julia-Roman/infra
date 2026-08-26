{
  mkService,
  pkgs,
  ...
}:
{
  systemd.services.cdn-helper = mkService "./cdn-helper" "/home/supa/projects/cdn-helper" [
    pkgs.ffmpeg-full
  ];
}
