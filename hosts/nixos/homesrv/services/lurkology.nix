{
  mkService,
  pkgs,
  ...
}:
{
  systemd.services.lurkology-api = mkService "./api" "/home/supa/projects/lurkology-api" [ ];
  systemd.services.lurkology-firehose =
    mkService "./firehose" "/home/supa/projects/lurkology-firehose"
      [ ];
  # ffmpeg decodes one keyframe per thumbnail
  systemd.services.lurkology-ingest = mkService "./ingest" "/home/supa/projects/lurkology-ingest" [
    pkgs.ffmpeg-headless
  ];
}
