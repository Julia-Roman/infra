{
  config,
  lib,
  ...
}:
{
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/0e3ff17e-9ee0-4c8c-884e-68648fa1fae9";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
        "relatime"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/0e3ff17e-9ee0-4c8c-884e-68648fa1fae9";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/0e3ff17e-9ee0-4c8c-884e-68648fa1fae9";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd"
        "relatime"
        "lazytime"
      ];
    };
    "/swap" = {
      device = "/dev/disk/by-uuid/0e3ff17e-9ee0-4c8c-884e-68648fa1fae9";
      fsType = "btrfs";
      options = [
        "subvol=swap"
        "noatime"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
    "/mnt/hdd_500g" = {
      device = "/dev/disk/by-uuid/83b3bfeb-4bdc-4270-9d8a-b2df53453f71";
      fsType = "btrfs";
      options = [
        "nofail"
        "noatime"
        "commit=60"
      ];
    };
    "/mnt/hdd_4t" = {
      device = "/dev/disk/by-uuid/9a742d1e-4aac-42d6-b514-b720f82334c3";
      fsType = "btrfs";
      options = [
        "nofail"
        "noatime"
        "commit=60"
      ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
