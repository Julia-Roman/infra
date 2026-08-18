{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./niri.nix
    ./noctalia.nix
  ];

  stylix = {
    enable = true;
    overlays.enable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    polarity = "dark";
    image = inputs.self + /assets/wallpaper.jpg;

    fonts = {
      sizes = {
        applications = 12;
        desktop = 12;
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      monospace = {
        package = pkgs.fantasque-sans-mono;
        name = "Fantasque Sans Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    opacity = {
      desktop = 0.8;
      popups = 0.8;
      terminal = 0.8;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "rose-pine-moon";
      package = pkgs.rose-pine-icon-theme;
    };
  };

  home = {
    username = "supa";
    homeDirectory = "/home/supa";

    stateVersion = "23.11"; # do not change

    pointerCursor = {
      name = "BreezeX-RosePineDawn-Linux";
      package = pkgs.rose-pine-cursor;
      size = 18;
      x11.enable = true;
      gtk.enable = true;
    };
  };

  news.display = "silent";

  programs = {
    home-manager.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "emacs";

      localVariables = {
        PS1 = "%F{240}[%F{183}%n%f@%F{117}%m %F{169}%~%F{240}]%f$ ";
      };

      shellAliases = {
        ls = "ls --color=auto --group-directories-first";
        l = "ls";
        la = "ls -a";
        ll = "ls -l";
        ka = "killall -I -r";
        update = "doas nixos-rebuild switch --flake ~/.dotfiles";
        ip = "ip -color=auto";
        grep = "grep --color=auto";
        vs = "code";
        s = "ssh";
        v = "vim";
        e = "hx";
        neofetch = "fastfetch";
      };

      initContent = ''
        zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}"

        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        bindkey "^H" backward-kill-word
        bindkey "5~" kill-word
        bindkey "^[[3~" delete-char
      '';
    };

    foot = {
      enable = true;
      settings = {
        main.pad = "8x8 center-when-fullscreen";
      };
    };

    kitty = {
      enable = true;
      font.size = 12;
      extraConfig = ''
        draw_minimal_borders yes
        resize_in_steps no
        dynamic_background_opacity yes

        map ctrl+shift+0 set_background_opacity +0.1
        map ctrl+shift+9 set_background_opacity -0.1

        symbol_map U+E0A0-U+E0A3,U+E0C0-U+E0C7 PowerlineSymbols
        symbol_map U+f000-U+f2e0 Font Awesome 6 Free
      '';
    };

    mpv = {
      enable = true;
      bindings = {
        G = "osd-msg-bar seek 100 absolute-percent+exact";

        RIGHT = "seek  5 exact"; # forward
        LEFT = "seek -5 exact"; # backward
        WHEEL_UP = "seek  5 exact"; # forward
        WHEEL_DOWN = "seek -5 exact"; # backward

        UP = "seek  30 exact"; # forward
        DOWN = "seek -30 exact"; # backward

        "Alt+=" = "add video-zoom 0.1";
      };
      config = {
        vo = "gpu-next";
        hwdec = "auto-copy";
        hwdec-codecs = "all";
        profile = "gpu-hq";
        dscale = "catmull_rom";
        #gpu-api="vulkan"; # might cause block artifacts on fast pacing videos (?)
        ao = "pipewire";

        screenshot-format = "png";
        screenshot-directory = "~/Pictures";
        screenshot-tag-colorspace = "no"; # because of gpu-next png tagging bug
        screenshot-high-bit-depth = "no";
        screenshot-png-compression = 6;
        screenshot-png-filter = 0;

        keep-open = "yes";
        force-window = "yes";
        write-filename-in-watch-later-config = "yes";
        save-position-on-quit = "yes";
        osd-bar-w = 40;
        osd-bar-h = 2;
        volume-max = 200;
        cursor-autohide = 100;
        sub-border-size = 2;
        #title="mpv";
      };
      profiles = {
        stream = {
          #vd-lavc-threads=1;
          demuxer-lavf-o-add = "fflags=+nobuffer+fastseek+flush_packets";
          demuxer-lavf-probe-info = "auto";
          demuxer-lavf-analyzeduration = 0.1;
          #demuxer-readahead-secs=30;
          demuxer-max-bytes = "128M";
          demuxer-max-back-bytes = "128M";
          #cache="no";
          gapless-audio = "yes";
          prefetch-playlist = "yes";
          #audio-buffer=0.1;
          #cache-secs=1;
          cache-pause = "no";
          untimed = "yes";
          video-sync = "audio";
          force-seekable = "yes";
          hr-seek = "yes";
          hr-seek-framedrop = "yes";
          interpolation = "no";
          video-latency-hacks = "yes";
          #stream-buffer-size="4k";
        };
      };
    };
  };

  services = {
    mpris-proxy.enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "thunar.desktop";

      "applications/x-www-browser" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";
      "x-scheme-handler/chrome" = "helium.desktop";
      "x-scheme-handler/about" = "helium.desktop";
      "x-scheme-handler/unknown" = "helium.desktop";
      "application/x-extension-htm" = "helium.desktop";
      "application/x-extension-html" = "helium.desktop";
      "application/x-extension-shtml" = "helium.desktop";
      "application/xhtml+xml" = "helium.desktop";
      "application/x-extension-xhtml" = "helium.desktop";
      "application/x-extension-xht" = "helium.desktop";
      "application/pdf" = "helium.desktop";

      "text/html" = "code.desktop";
      "text/plain" = "code.desktop";
      "application/octet-stream" = "code.desktop";
      "application/x-zerosize" = "code.desktop";

      "image/png" = "org.xfce.ristretto.desktop";
      "image/jpg" = "org.xfce.ristretto.desktop";
      "image/jpeg" = "org.xfce.ristretto.desktop";
      "image/gif" = "org.xfce.ristretto.desktop";
      "image/webp" = "org.xfce.ristretto.desktop";
      "image/heic" = "org.xfce.ristretto.desktop";
      "image/apng" = "org.xfce.ristretto.desktop";
      "image/svg+xml" = "org.xfce.ristretto.desktop";

      "video/*" = "mpv.desktop";
    };
  };

  xdg.configFile = {
    "xfce4/helpers.rc".text = ''
      TerminalEmulator=foot
      FileManager=thunar
      WebBrowser=helium
      MailReader=thunderbird
      TextEditor=code
      VideoPlayer=mpv
      ImageViewer=ristretto
      ArchiveManager=file-roller
    '';
  };
}
