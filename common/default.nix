{
  inputs,
  hostname,
  pkgs,
  ...
}:
{
  imports = [
    ./nix.nix
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    agenix
    git
    vim
    bottom
    wget
    nixd
    nixfmt-rfc-style
  ];

  networking = {
    hostName = hostname;

    nameservers = [
      "192.168.1.1"
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };

  hardware.enableAllFirmware = true;

  system.configurationRevision = inputs.self.rev or "dirty";
}
