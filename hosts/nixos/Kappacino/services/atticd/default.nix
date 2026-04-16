{
  ...
}:
{
  services.atticd = {
    enable = true;
    environmentFile = "/etc/atticd.env";
    settings = {
      listen = "127.0.0.1:47710";
      api-endpoint = "https://attic.supa.sh/";
      compression.type = "none";
      jwt = { };
      database.url = "postgresql://attic@localhost:5432/attic";
    };
  };
}
