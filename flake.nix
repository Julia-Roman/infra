{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix.url = "github:nix-community/fenix";
    niri.url = "github:sodiboo/niri-flake";
    dms.url = "github:AvengeMedia/DankMaterialShell";
    stylix.url = "github:nix-community/stylix/release-25.11";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    technorino.url = "git+https://github.com/2547techno/technorino?submodules=1";
    uploader-basic.url = "github:0Supa/uploader-basic";

    yt-dlp-git = {
      url = "github:yt-dlp/yt-dlp";
      flake = false;
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;

      mkHost =
        system: hostname:
        let
          builder =
            if system == "darwin" then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
          config = builder {
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/${system}/${hostname}
              ./common
              { config._module.args = { inherit hostname; }; }
            ];
          };
          key = "${system}Configurations";
        in
        {
          ${key} = {
            ${hostname} = config;
          };
        };

      systems = builtins.attrNames (builtins.readDir ./hosts);

      hosts = builtins.concatMap (
        system:
        let
          hostnames = builtins.attrNames (builtins.readDir (./hosts + "/${system}"));
        in
        map (hostname: mkHost system hostname) hostnames
      ) systems;

    in
    builtins.foldl' lib.recursiveUpdate { } hosts;

  nixConfig = {
    download-buffer-size = "256M";
    extra-substituters = [ "https://supa.cachix.org" ];
    extra-trusted-substituters = [ "https://supa.cachix.org" ];
    extra-trusted-public-keys = [
      "supa.cachix.org-1:+rC20DiSj3IB8u8LgKV30nYAOwk9vP9aty3rdFz9/YM="
    ];
  };
}
