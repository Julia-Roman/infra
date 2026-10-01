{
  lib,
  pkgs,
  unstable,
  ...
}:
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
      WHISPER_MODEL = "${pkgs.fetchurl {
        url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.en.bin";
        sha256 = "0p8yqkwvpl9lyy43yajk305bps0v5z1qgyg0jwh35j7cb1nqs4y6";
      }}";
      YUNET_MODEL = "${pkgs.fetchurl {
        url = "https://media.githubusercontent.com/media/opencv/opencv_zoo/main/models/face_detection_yunet/face_detection_yunet_2023mar.onnx";
        sha256 = "191gap94x0040qlg9yb4r46j28q4zh3q2wd87rav9yrwvpj868wg";
      }}";
      DISABLE_AUTOUPDATER = "1";
      LIBVA_DRIVER_NAME = "iHD";
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      # files workflows publish over https, served by the /files route in caddy.nix
      PUBLIC_FILES_DIR = "/var/lib/n8n-public";
      PUBLIC_FILES_URL = "https://n8n.supa.codes/files";
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
      (whisper-cpp.override { vulkanSupport = true; })
      (python3.withPackages (ps: [
        ps.opencv4
        ps.numpy
        ps.playwright
      ]))
      unstable.claude-code
    ];
    # scripts for Execute Command nodes, kept outside this repo
    serviceConfig = {
      BindReadOnlyPaths = [ "-/home/supa/git/n8n-private:/opt/n8n" ];
      # CLAUDE_CODE_OAUTH_TOKEN from `claude setup-token`
      EnvironmentFile = "-/etc/n8n.env";
      # iGPU for VA-API encode/decode and Vulkan whisper
      PrivateDevices = lib.mkForce false;
      DeviceAllow = [ "/dev/dri/renderD128 rw" ];
      SupplementaryGroups = [
        "render"
        "n8n-public"
      ];
      ReadWritePaths = [ "/var/lib/n8n-public" ];
    };
  };

  # public files: n8n writes, caddy serves, cleaned up after 2 days
  users.groups.n8n-public = { };
  users.users.caddy.extraGroups = [ "n8n-public" ];
  systemd.tmpfiles.rules = [ "d /var/lib/n8n-public 2770 root n8n-public 2d" ];
}
