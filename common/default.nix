{
  inputs,
  hostname,
  pkgs,
  ...
}:
{
  imports = [
    ./lib.nix
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
    nixfmt
    acl
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

  # /tmp is tmpfs; keep Claude Code's temp files on disk
  environment.sessionVariables.CLAUDE_CODE_TMPDIR = "/var/tmp";

  hardware.enableAllFirmware = true;

  system.configurationRevision = inputs.self.rev or "dirty";
}
