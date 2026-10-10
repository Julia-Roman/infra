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
      "async"
      "fsc"
      "nocto"
      "noatime"
      "nosuid"
      "nodev"
      "noexec"
      "nofail"
      "noauto"
      "x-systemd.automount"
      "_netdev"
      "soft"
      "timeo=50"
      "retrans=2"
      "retry=0"
      "x-systemd.mount-timeout=15"
    ];
  };

  services = {
    xserver.videoDrivers = [ "intel" ];

    openssh = {
      enable = true;
      ports = [ 38126 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
      openFirewall = true;
    };

    udev.enable = true;

    smartd.enable = true;

    vnstat.enable = true;

    jellyfin.enable = true;

    postgresql = {
      enable = true;
      enableTCPIP = true;
      settings = {
        shared_preload_libraries = "pg_stat_statements";
        # the defaults size Postgres for a small VM on spinning disks; this host has 31 GB and NVMe
        shared_buffers = "4GB";
        effective_cache_size = "12GB";
        work_mem = "16MB";
        maintenance_work_mem = "512MB";
        random_page_cost = 1.1;
        effective_io_concurrency = 200;
        max_wal_size = "4GB";
      };
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
