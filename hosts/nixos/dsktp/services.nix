{
  lib,
  pkgs,
  ...
}:
{
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.tuigreet} --time --cmd niri-session";
          user = "supa";
        };
      };
    };

    power-profiles-daemon.enable = true;

    gvfs.enable = true;
    tumbler.enable = true;

    # extraRules lands in 99-local.rules, too late for uaccess (applied by 73-seat-late.rules).
    udev.packages = [
      (pkgs.writeTextDir "lib/udev/rules.d/70-nuphy.rules" ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="19f5", TAG+="uaccess"
      '')
    ];
  };
}
