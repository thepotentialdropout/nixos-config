{
  config,
  pkgs,
  vars,
  lib,
  ... 
  }: let
  renderDevice = "/dev/dri/renderD128";
in 
{
  sops.secrets = {
    "wg.conf" = {
      format = "binary";
      sopsFile = ./../secrets/wg.conf ;
      };
  };
  
  services.flaresolverr = {
    enable = true;
    openFirewall = true;
  };

  nixarr = {
    enable = true;
    mediaDir = "/mnt/hdd01/media";
    stateDir = "/mnt/hdd01/media/.state";

    jellyfin.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    sonarr.enable = true;
    seerr.enable = true;

    qbittorrent = {
      enable = true;
      peerPort = 51820; # Set this to the port forwarded by your VPN
      webuiPort = 5252; # Port for the qui WebUI (default)

      # Disable DHT/PeX for private trackers (optional)
      # privateTrackers.disableDhtPex = true;

      # Extra qBittorrent configuration (optional)
      # See: https://github.com/qbittorrent/qBittorrent/wiki/Explanation-of-Options-in-qBittorrent
      extraConfig = {
        BitTorrent = {
          "Session\\MaxActiveDownloads" = 3;
          "Session\\MaxActiveTorrents" = 5;
        };
      };
    };

    exporters.enable = true;

    vpn = {
      enable = true;
      wgConf = config.sops.secrets."wg.conf".path;
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };

  services.jellyfin = {
    hardwareAcceleration = {
      enable = true;
      type = "vaapi";
      device = renderDevice;
    };
    transcoding = {
      enableHardwareEncoding = true;
      enableToneMapping = true;
      hardwareDecodingCodecs = {
        h264 = true;
        hevc = true;
        mpeg2 = true;
        vc1 = true;
        vp8 = true;
        vp9 = true;
      };
      hardwareEncodingCodecs.hevc = true;
    };
  };

  services.nginx = {
    virtualHosts = {
      "watch.${vars.domain}" = {
        forceSSL = true;
        useACMEHost = vars.domain;
        locations."/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:${toString config.nixarr.jellyfin.port}";
          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };

      "prowlarr.${vars.domain}" = {
        forceSSL = true;
        useACMEHost = vars.domain;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:${toString config.nixarr.prowlarr.port}";
        };
      };

      "radarr.${vars.domain}" = {
        forceSSL = true;
        useACMEHost = vars.domain;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:${toString config.nixarr.radarr.port}";
        };
      };

      "sonarr.${vars.domain}" = {
        forceSSL = true;
        useACMEHost = vars.domain;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:${toString config.nixarr.sonarr.port}";
        };
      };

    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      intel-media-driver
      libvdpau-va-gl
      intel-vaapi-driver
      libva-vdpau-driver
    ];
  };

  environment.systemPackages = with pkgs; [
    # To enable `intel_gpu_top`
    intel-gpu-tools
    # because nixarr does not include it by default
    wireguard-tools
  ];
  



}
