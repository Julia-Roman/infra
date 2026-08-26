{
  mkService,
  ...
}:
{
  systemd.services.spacetimedb =
    mkService "./spacetime start --listen-addr 0.0.0.0:12661"
      "/home/supa/git/SpacetimeDB/target/release"
      [ ];
}
