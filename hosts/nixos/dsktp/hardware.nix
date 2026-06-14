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
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/9ba04741-7077-4113-b782-f44ccf7329de";
      fsType = "ext4";
      options = [
        "relatime"
        "lazytime"
        "commit=60"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/4D2E-4142";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
