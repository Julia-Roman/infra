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
    };
  };

  systemd.services.n8n.path = with pkgs; [
    ffmpeg-full
    yt-dlp-git
    imagemagick
  ];
}
