{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.spicetify-nix.nixosModules.spicetify
  ];

  programs = {
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    firefox.enable = true;

    zsh.enable = true;

    steam.enable = true;
    gamemode.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    obs-studio = {
      enable = true;
      package = pkgs.obs-studio.override {
        cudaSupport = true;
      };
      plugins = with pkgs.obs-studio-plugins; [
        obs-gstreamer
        waveform
        obs-pipewire-audio-capture
      ];
    };

    spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          adblockify
          shuffle
        ];
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
      };

    nix-ld.enable = true;
  };
}
