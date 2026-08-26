{
  mkService,
  ...
}:
{
  systemd.services.whatbot = mkService "./whatbot" "/home/supa/projects/whatbot" [ ];
}
