{ pkgs, unstable, ... }:
{
  services.n8n = {
    enable = true;
    package = unstable.n8n;
    environment = {
      N8N_PORT = 5678;
      N8N_HOST = "n8n.supa.codes";
      N8N_PROTOCOL = "https";
      WEBHOOK_URL = "https://n8n.supa.codes/";
      N8N_PROXY_HOPS = 1;
      # n8n 2.x excludes Execute Command by default, needed for ffmpeg
      NODES_EXCLUDE = "[]";
      N8N_DEFAULT_BINARY_DATA_MODE = "filesystem";
      # n8n compares realpaths against this list, and DynamicUser makes
      # /var/lib/n8n a symlink to /var/lib/private/n8n
      N8N_RESTRICT_FILE_ACCESS_TO = "/var/lib/n8n/.n8n-files;/var/lib/private/n8n/.n8n-files";
      FONTS_DIR = "${pkgs.montserrat}/share/fonts/ttf";
    };
  };

  systemd.services.n8n = {
    path = with pkgs; [
      bash
      curl
      ffmpeg-full
      yt-dlp-git
      jq
      imagemagick
    ];
    # scripts for Execute Command nodes, kept outside this repo
    serviceConfig.BindReadOnlyPaths = [ "-/home/supa/git/n8n-private:/opt/n8n" ];
  };
}
