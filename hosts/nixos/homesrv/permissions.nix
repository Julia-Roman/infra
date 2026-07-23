{
  ...
}:
{
  systemd.tmpfiles.settings = {
    "10-custom-permissions-nix" = {
      "/mnt/hdd_4t".z = {
        mode = "0775";
        user = "supa";
      };
      "/mnt/hdd_4t/movies".z = {
        mode = "2770";
        group = "media";
      };
      "/mnt/hdd_4t/music".z = {
        mode = "2770";
        group = "media";
      };
      "/mnt/hdd_500g".z = {
        mode = "2770";
        group = "media";
      };
      "/var/www".z = {
        mode = "2770";
        user = "supa";
        group = "www";
      };
      "/home/minecraft".z = {
        mode = "2770";
        group = "minecraft";
      };

      "/home/fivem".z = {
        mode = "2770";
        group = "fivem";
      };
      "/home/fivem"."A+" = {
        argument = "group:fivem:rwx,default:group:fivem:rwx";
      };
    };
  };

  # always reapply permissions
  systemd.services."systemd-tmpfiles-resetup".partOf = [ "sysinit-reactivation.target" ];
}
