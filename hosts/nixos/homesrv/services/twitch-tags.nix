{
  mkService,
  pkgs,
  ...
}:
{
  systemd.services.twitch-tags = mkService "node ." "/home/supa/projects/twitch-tags" [ pkgs.nodejs ];
}
