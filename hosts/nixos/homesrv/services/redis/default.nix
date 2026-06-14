{
  ...
}:
{
  services.redis.servers = {
    "" = {
      enable = true;
      port = 6379;
    };
    "umami" = {
      enable = true;
      port = 6381;
    };
  };
}
