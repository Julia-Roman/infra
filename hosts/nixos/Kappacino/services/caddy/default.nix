{
  pkgs,
  config,
  ...
}:
{
  services.caddy = {
    enable = true;
    email = "supa.codes@gmail.com";

    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/mholt/caddy-ratelimit@v0.1.0"
      ];
      hash = "sha256-/aeCFzPTZKe1wvfQltGpPLyHMyzyugUIavc0HanCh1Q=";
    };

    virtualHosts = {
      "(static)" = {
        extraConfig = ''
          @static {
            file
            path *.ico *.css *.js *.gif *.webp *.avif *.jpg *.jpeg *.png *.svg *.woff *.woff2 *.mp4 *.webm
          }
          header @static Cache-Control max-age=5184000
          encode zstd gzip
        '';
      };

      "supa.codes" = {
        extraConfig = ''
          redir / https://supa.sh/ permanent
          root * /var/www/supa.codes
          file_server
          import static

          handle_path /clipper/* {
            basic_auth {
              api $2a$14$XAF/HBVE//6UOQ4d2AoqBu7jVS2t19/G53tktv8q1eTrEVPf9hRRG
            }
            reverse_proxy :8989
          }
          handle_path /twitch-clip-queue/* {
            root * /var/www/supa.codes/twitch-clip-queue
            try_files {path} /index.html
            file_server
          }
        '';
      };

      "supa.sh" = {
        extraConfig = ''
          root * /var/www/supa.sh
          file_server
          import static
        '';
      };

      "home.supa.sh" = {
        serverAliases = [ "supa.home.ro" ];
        extraConfig = ''
          redir * https://supa.sh/ permanent
        '';
      };

      "supa.gay" = {
        extraConfig = ''
          redir * https://bsky.app/profile/supa.gay
        '';
      };

      "reddit.supa.gay" = {
        extraConfig = ''
          reverse_proxy :${toString config.services.redlib.port}

          rate_limit {
            zone redlib {
              match {
                path / /r/* /user/*
              }
              key    {header.CF-Connecting-IP}
              events 10
              window 10s
            }
          }
        '';
      };

      "pin.supa.gay" = {
        extraConfig = ''
          php_fastcgi unix/${config.services.phpfpm.pools.caddy.socket}

          root * /var/www/pin.supa.gay
          file_server
          import static

          rate_limit {
            zone binternet {
              match {
                not remote_ip private_ranges
                not path /image_proxy.php
              }
              key    {remote_host}
              events 20
              window 10s
            }
          }
        '';
      };

      "zonian.is.supa.gay" = {
        extraConfig = ''
          redir * https://zonian.dev/ permanent
        '';
      };

      "pgp.supa.sh" = {
        extraConfig = ''
          redir * https://fi.supa.sh/supa_pgp.asc permanent
        '';
      };

      "probe.supa.codes" = {
        serverAliases = [ "probe.supa.sh" ];
        extraConfig = ''
          reverse_proxy :1890

          rate_limit {
            zone probe_cdn {
              match {
                not remote_ip private_ranges 159.69.37.33
                not header CF-Connecting-IP 159.69.37.33
              }
              key    {header.CF-Connecting-IP} || {remote_host}
              events 100
              window 60s
            }
          }
        '';
      };

      "api-tv.supa.sh" = {
        extraConfig = ''
          @liveapi path /tags/*
          handle @liveapi {
            reverse_proxy localhost:3420
          }

          handle {
            header Access-Control-Allow-Origin *
            reverse_proxy :7813
          }

          rate_limit {
            zone api_tv {
              match {
                not remote_ip private_ranges
              }
              key    {header.CF-Connecting-IP}
              events 50
              window 10s
            }
          }
        '';
      };

      "tv.supa.codes" = {
        extraConfig = ''
          redir https://tv.supa.sh{uri} permanent
        '';
      };

      "fi.supa.sh" = {
        serverAliases = [ "cf-fi.supa.sh" ];
        extraConfig = ''
          header Access-Control-Allow-Origin *
          php_fastcgi unix/${config.services.phpfpm.pools.caddy.socket}

          # @direct_access expression {path}.endsWith(".php")
          # respond @direct_access 403

          @opengraph expression {path}.endsWith(".mp4") && ({header.User-Agent}.startsWith("chatterino-api-cache/") || {header.User-Agent}.contains("FFZBot/"))
          handle @opengraph {
            header >Cache-Control no-cache
            try_files /.scripts/opengraph.php
          }

          root * /var/www/fi.supa.sh
          file_server
          import static
          try_files {path} indexer.php
        '';
      };

      "i.supa.sh" = {
        extraConfig = ''
          basic_auth /api/upload {
            supa $2a$14$UStJvpPMSVy9h7xXFEy6zuOTTOac3cPHf8fol0KuXvwdlCPf.A9jW
            kazimir33 $2a$14$ypyN8wUcb0oho91/7ltWMebaeMspdAGHxEygxNxmlLsxJnjU2oEqi
            soul $2a$14$eX2SOE3mF3MCt09AgxlnkeJ4U6Iwr3SWmERqG0TBCuFEN.pztAbAu
          }

          root * /var/www/i.supa.sh
          file_server

          header Access-Control-Allow-Origin *

          encode zstd gzip

          request_body {
            max_size 1024MB
          }

          redir / https://supa.sh/

          handle /api/* {
            reverse_proxy :7421
          }

          handle /robots.txt {
            respond <<EOF
            User-agent: *
            Disallow: /
            EOF 200
          }

          handle {
            try_files {path} {file.base}.*
          }

          @opengraph expression {header.User-Agent}.startsWith("chatterino-api-cache/") || {header.User-Agent}.contains("FFZBot/")
          handle @opengraph {
            header >Cache-Control no-cache
            templates
            try_files /templates/thumbnail.html
          }

          rate_limit {
            zone filehost {
              match {
                not remote_ip private_ranges
              }
              key    {remote_host}
              events 100
              window 60s
            }
          }
        '';
      };

      "jelly.supa.sh" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8096
        '';
      };

      "qbt.supa.sh" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8113
        '';
      };

      "pogly.supa.sh" = {
        extraConfig = ''
          import static

          @spacetime {
            path /identity/*
            path /database/*
            path /energy/*
          }

          handle @spacetime {
            reverse_proxy localhost:12661
          }

          handle {
            root * /var/www/pogly.supa.sh
            try_files {path} /index.html
            file_server
            header @static Cache-Control max-age=5184000
          }
        '';
      };

      "logs.supa.codes" = {
        extraConfig = ''
          redir / https://tv.supa.sh/logs{uri} permanent

          handle /robots.txt {
            respond <<EOF
            User-agent: *
            Disallow: /
            EOF 200
          }

          reverse_proxy :8025
          encode zstd gzip

          rate_limit {
            zone logs {
              match {
                not remote_ip private_ranges
              }
              key    {header.CF-Connecting-IP}
              events 30
              window 10s
            }
          }
        '';
      };

      "chat.supa.codes" = {
        extraConfig = ''
          @trailing path_regexp trailing ^(.+)/$
          redir @trailing {re.trailing.1} permanent

          root * /var/www/chat.supa.codes
          try_files {path}.html
          file_server
          import static
        '';
      };

      "metrics.supa.codes" = {
        extraConfig = ''
          reverse_proxy :3133
        '';
      };

      "umami.supa.codes" = {
        serverAliases = [ "intel.supa.sh" ];
        extraConfig = ''
          reverse_proxy :1700
        '';
      };

      "live.supa.sh" = {
        extraConfig = ''
          reverse_proxy :8889
        '';
      };

      "mtx-hls.supa.sh" = {
        extraConfig = ''
          reverse_proxy :8888
        '';
      };

      "mc.supa.sh" = {
        extraConfig = ''
          redir /bluemap /bluemap/ permanent
          redir / /bluemap
          handle_path /bluemap/* {
            reverse_proxy :8100
          }
          encode zstd gzip
        '';
      };

      "txadmin.supa.codes" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:40120
        '';
      };

      "rp.supa.sh" = {
        extraConfig = ''
          redir * https://discord.gg/pGp8RkxKdu
        '';
      };

      "3pixeli.ro" = {
        serverAliases = [
          "www.3pixeli.ro"
          "rp.3pixeli.ro"
        ];
        extraConfig = ''
          redir / https://wiki.3pixeli.ro

          redir /discord https://discord.gg/pGp8RkxKdu
          redir /youtube https://www.youtube.com/@3Pixeli
          redir /tiktok https://www.tiktok.com/@3pixeli
          redir /github https://github.com/3pixeli
        '';
      };

      "logs.zonian.dev" = {
        serverAliases = [ "bestlogs.supa.codes" ];
        extraConfig = ''
          reverse_proxy :10002
          encode zstd gzip

          rate_limit {
            zone bestlogs {
              match {
                not remote_ip private_ranges
              }
              key    {remote_host}
              events 30
              window 10s
            }
          }
        '';
      };
    };
  };

  services.phpfpm.pools.caddy = {
    user = "caddy";
    settings = {
      "listen.owner" = config.services.caddy.user;
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
    };
  };
}
