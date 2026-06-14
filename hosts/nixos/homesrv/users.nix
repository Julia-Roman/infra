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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEv4PWtdTzuobEzEccSWgF2LJrjqgJI4s2bt3QJHqkiC supa@Kappa"
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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEv4PWtdTzuobEzEccSWgF2LJrjqgJI4s2bt3QJHqkiC supa@Kappa"
        ];
        group = "fivem";
        createHome = true;
        home = "/home/fivem";
        linger = true;
      };

      omuljake = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgfgQrYupRruKqTpuzlqNXqBVyKo+vfPXyCypSJLM9f omuljake"
        ];
        createHome = true;
        extraGroups = [ "fivem" ];
        home = "/home/omuljake";
      };

      goku = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7U1x00A2ocDIEHFFkbeo5c1/5mmPCV8qiDvJf9qiMt goku"
        ];
        createHome = true;
        extraGroups = [ "fivem" ];
        home = "/home/goku";
      };

      chimichanga = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClexd1XfqBrbgd3TWr4bI4ATkr/a/utc9WXlUBaBD+AsiiF5stUvmcn9G1BBr3k9xHmS1iiCBpa6DDKpR6Dvcw2m/lgVFr2oNw/aQJqjlcL7KLEidNHwk2hE1Q9MmTHPaqfWaRkMO1U60sdSRekjggWs2Seqo3PysEHeZvTA1KLAoduPjta6S337Aoye3UIRIxMUXMV0ekfaFTON+Q/1UBvY4NBHZN973sep17Sy6SDPEQ0vl73tRKJw/PjrgZWm6xy2i0tPmekAUmI4rVIku7WW0d619BLhi+nMOA8+WGys2oTM/LL6bYxYcfAFbRfsyGbZUymALzLluYNAUWA24b chimi"
        ];
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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAKmAw/vWetH/lD2US2aFDYfKxT4gMA+s/BqYCOFzz5u me@joet.me"
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
