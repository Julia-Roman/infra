{
  config,
  lib,
  inputs,
  pkgs,
  unstable,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # Essential
    xz
    htop
    nvitop
    playerctl
    psmisc
    compsize
    pkg-config
    config.boot.kernelPackages.cpupower
    busybox
    libclang
    wl-clipboard
    doas-sudo-shim
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
  ];

  users.users.supa.packages = with pkgs; [
    # Internet
    librewolf
    chromium
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.technorino.packages.${pkgs.stdenv.hostPlatform.system}.default
    electrum # BTC wallet
    # monero-gui # XMR wallet
    qbittorrent
    webcord-vencord
    thunderbird
    discord

    # Utils/Misc
    xwayland-satellite-unstable
    kitty # Terminal
    foot
    fastfetch
    ffmpeg-full
    yt-dlp-git
    file-roller # Archive manager
    pavucontrol # Volume control
    keepassxc # Password manager
    songrec # Shazam song recognition
    filezilla
    dig
    ripgrep
    gnupg
    libreoffice
    zulu8
    zulu17

    # Dev
    vscode
    insomnia
    gh
    gcc
    nodejs
    typescript-language-server
    go
    gopls
    fenix.default.toolchain
    nil
    php

    # Multimedia
    xfce.ristretto # Image viewer
    mpv
    jellyfin-mpv-shim
    jellyfin-rpc
    cider-2
    audacity
    imagemagick

    # Games
    prismlauncher # Minecraft launcher
  ];
}
