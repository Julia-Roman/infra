{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix.url = "github:nix-community/fenix";
    niri.url = "github:sodiboo/niri-flake";
    stylix.url = "github:nix-community/stylix/release-26.05";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    technorino.url = "git+https://github.com/2547techno/technorino?submodules=1";
    uploader-basic.url = "github:Julia-Roman/uploader-basic";
    bestlogs-rs.url = "github:Julia-Roman/bestlogs-rs";

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
    extra-substituters = [ "https://attic.supa.sh/infra" ];
    extra-trusted-substituters = [ "https://attic.supa.sh/infra" ];
    extra-trusted-public-keys = [
      "infra:fDwImWlNBAN6+Vte3W4aC+qLSIP0rOyO+j7+uqegNkY="
    ];
  };
}
