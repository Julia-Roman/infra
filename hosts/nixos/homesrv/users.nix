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
        isSystemUser = true;
        group = "fivem";
        createHome = true;
        home = "/home/fivem";
        linger = true;
      };

      qbittorrent = {
        isSystemUser = true;
        group = "media";
        createHome = true;
        home = "/var/lib/qbittorrent";
      };

      jellyfin.extraGroups = [ "media" ];
      caddy.extraGroups = [ "www" ];

      omuljake = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINYXj7DSfF7bzZxN8cV86m0v+58ZwfxbWfx4hDu7kxOT omuljake"
        ];
        extraGroups = [ "fivem" ];
      };

      goku = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgt0vqaXWSmTaIjI1q/AoWLoImK/Ecb8pa2G/q+2hbQ goku"
        ];
        extraGroups = [ "fivem" ];
      };

      chimichanga = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClexd1XfqBrbgd3TWr4bI4ATkr/a/utc9WXlUBaBD+AsiiF5stUvmcn9G1BBr3k9xHmS1iiCBpa6DDKpR6Dvcw2m/lgVFr2oNw/aQJqjlcL7KLEidNHwk2hE1Q9MmTHPaqfWaRkMO1U60sdSRekjggWs2Seqo3PysEHeZvTA1KLAoduPjta6S337Aoye3UIRIxMUXMV0ekfaFTON+Q/1UBvY4NBHZN973sep17Sy6SDPEQ0vl73tRKJw/PjrgZWm6xy2i0tPmekAUmI4rVIku7WW0d619BLhi+nMOA8+WGys2oTM/LL6bYxYcfAFbRfsyGbZUymALzLluYNAUWA24b chimi"
        ];
        extraGroups = [ "fivem" ];
        linger = true;
      };

      fui = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdu/8WZGXWasf/7hjAWI4uwi3KaBIUjURlNC7A9s34V fui"
        ];
        extraGroups = [ "fivem" ];
      };

      zonian = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADNDlNyn1HGSOpBUBR4lalWNZoiFzAQrnKaRH7dxFS/ zonianmidian@gmail.com"
        ];
        linger = true;
      };
    };
  };
}
