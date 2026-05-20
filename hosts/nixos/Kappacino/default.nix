{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./users.nix
    ./permissions.nix
    ./network.nix
  ]
  ++ (import ./services);

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    kernel.sysctl = {
      "vm.swappiness" = 1;
      "vm.nr_hugepages" = 4096;
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  time.timeZone = "UTC";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  }; # Force intel-media-driver

  security = {
    sudo.wheelNeedsPassword = false;
    sudo.execWheelOnly = true;
    rtkit.enable = true;
  };

  fileSystems."/var/www/fi.supa.sh/clips" = {
    device = "10.2.0.1:/supelle";
    fsType = "nfs";
    options = [
      "fsc"
      "noatime"
      "nofail"
      "noauto"
      "x-systemd.automount"
      "_netdev"
    ];
  };

  services = {
    xserver.videoDrivers = [ "intel" ];

    openssh = {
      enable = true;
      ports = [ 38126 ];
      settings.PasswordAuthentication = false;
      openFirewall = true;
    };

    udev.enable = true;

    smartd.enable = true;

    vnstat.enable = true;

    jellyfin.enable = true;

    postgresql = {
      enable = true;
      enableTCPIP = true;
    };

    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    clickhouse.enable = true;
  };

  programs.nix-ld.enable = true;

  environment.etc."clickhouse-server/config.xml".source =
    lib.mkForce ./etc/clickhouse-server/config.xml;

  system.stateVersion = "23.11";
}
