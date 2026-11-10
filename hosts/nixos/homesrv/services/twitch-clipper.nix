{
  lib,
  mkService,
  pkgs,
  ...
}:
{
  systemd.services.twitch-clipper =
    lib.recursiveUpdate
      (mkService "./twitch-clipper" "/home/supa/projects/twitch-clipper" [
        pkgs.ffmpeg-full
      ])
      {
        # without the clips mount it would write into the empty directory underneath
        unitConfig.RequiresMountsFor = "/var/www/fi.supa.sh/clips";
      };
}
