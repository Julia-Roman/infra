{
  ...
}:
{
  users = {
    groups = {
      www = { };
      media = { };
      fivem = { };
      minecraft = { };
    };

    users = {
      supa = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEv4PWtdTzuobEzEccSWgF2LJrjqgJI4s2bt3QJHqkiC supa@dsktp"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIxBWxWouib3LC0VP9nSMA4AssxXZUXmgPSM6B1YHOdj supa iph15"
        ];
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "www"
          "media"
          "fivem"
          "minecraft"
        ];
        linger = true;
      };

      minecraft = {
        isSystemUser = true;
        group = "minecraft";
        createHome = true;
        home = "/home/minecraft";
      };

      fivem = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEv4PWtdTzuobEzEccSWgF2LJrjqgJI4s2bt3QJHqkiC supa@dsktp"
        ];
        group = "fivem";
        createHome = true;
        home = "/home/fivem";
        linger = true;
      };

      omuljake = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINYXj7DSfF7bzZxN8cV86m0v+58ZwfxbWfx4hDu7kxOT omuljake"
        ];
        createHome = true;
        extraGroups = [ "fivem" ];
        home = "/home/omuljake";
      };

      goku = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL4e4mtPZHbrATBkdeq37UfW5SuS8dVsZGibuC0DmaB5 goku"
        ];
        createHome = true;
        extraGroups = [ "fivem" ];
        home = "/home/goku";
      };

      chimichanga = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [ ];
        createHome = true;
        extraGroups = [ "fivem" ];
        home = "/home/chimichanga";
      };

      qbittorrent = {
        isSystemUser = true;
        group = "media";
        createHome = true;
        home = "/var/lib/qbittorrent";
      };

      zonian = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADNDlNyn1HGSOpBUBR4lalWNZoiFzAQrnKaRH7dxFS/ zonianmidian@gmail.com"
        ];
        createHome = true;
        home = "/home/zonian";
        linger = true;
      };

      jellyfin.extraGroups = [ "media" ];
      caddy.extraGroups = [ "www" ];
    };
  };
}
