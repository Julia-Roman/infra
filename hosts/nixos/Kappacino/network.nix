{
  ...
}:
{
  networking = {
    interfaces.enp2s0.wakeOnLan.enable = true;
    nftables.enable = true;

    firewall = {
      # Other ports might be opened by services (openFirewall = true)
      enable = true;
      allowedTCPPorts = [
        80
        443
        57386 # bittorrent
        25565 # Minecraft
        1935 # RTMP
        8554 # RTSP
        30120 # FiveM
      ];
      allowedUDPPorts = [
        80
        443
        57386 # bittorrent
        8080 # srt-relay
        8189 # WebRTC (ICE)
        8890 # SRT
        24454 # Minecraft (voicechat)
        30120 # FiveM
        51820 # WireGuard
      ];
    };

    wireguard.interfaces = {
      # franta
      wg0 = {
        ips = [ "10.2.0.2/24" ];
        listenPort = 51820;
        privateKeyFile = "/root/.wireguard/privatekey";
        peers = [
          {
            endpoint = "77.48.27.53:51821";
            publicKey = "3mY64NBkRi/CHbdIj3mAABUV1s3Ugf97H5UxpE11dHw=";
            allowedIPs = [ "10.2.0.1/32" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
