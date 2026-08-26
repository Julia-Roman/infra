{
  mkService,
  ...
}:
{
  systemd.services.srt-stream-receiver =
    mkService "./srt-stream-receiver" "/home/supa/projects/srt-stream-receiver"
      [ ];
}
