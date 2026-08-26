{
  mkService,
  ...
}:
{
  systemd.services.rustlog = mkService "./rustlog" "/home/supa/git/rustlog" [ ];
}
