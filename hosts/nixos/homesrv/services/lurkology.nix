{
  mkService,
  ...
}:
{
  systemd.services.lurkology-api = mkService "./api" "/home/supa/projects/lurkology-api" [ ];
  systemd.services.lurkology-firehose =
    mkService "./firehose" "/home/supa/projects/lurkology-firehose"
      [ ];
}
