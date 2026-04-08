{
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs = {
    config.allowUnfree = true;

    overlays = (import ./overlays inputs) ++ [
      inputs.nixpkgs-wayland.overlays.default
      inputs.agenix.overlays.default
      inputs.fenix.overlays.default
      inputs.niri.overlays.niri
    ];
  };

  nix = {
    package = pkgs.lixPackageSets.stable.lix;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      trusted-users = [
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      warn-dirty = false;
      builders-use-substitutes = true;
    };
  };

  _module.args = with pkgs.stdenv.hostPlatform; {
    unstable = import inputs.nixpkgs-unstable {
      system = pkgs.system;
      config.allowUnfree = true;
    };
  };
}
