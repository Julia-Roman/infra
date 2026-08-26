{
  mkService,
  pkgs,
  ...
}:
{
  systemd.services.twitch-clipper =
    mkService "./twitch-clipper" "/home/supa/projects/twitch-clipper"
      [
        pkgs.ffmpeg-full
      ];
}
