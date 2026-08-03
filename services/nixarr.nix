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

  nixarr = {
    enable = true;
    mediaDir = "/mnt/hdd01/media";
    stateDir = "var/lib/nixarr";

    jellyfin.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    sonarr.enable = true;

    transmission = {
      enable = true;
      package = pkgs.transmission_4;
      # todo: figure out how to update this easier
      peerPort = 51820;
      extraSettings = {
        peer-limit-global = 200;
        cache-size-mb = 256;
        incomplete-dir = "/var/lib/transmission/.incomplete";
        incomplete-dir-enabled = true;
        download-queue-enabled = true;
        download-queue-size = 20;
        speed-limit-up = 500;
        speed-limit-up-enabled = true;
      };
    };

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
          proxyPass = "http://192.168.178.186:${toString config.nixarr.jellyfin.port}";
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
          proxyPass = "http://192.168.178.186:${toString config.nixarr.prowlarr.port}";
        };
      };

      "radarr.${vars.domain}" = {
        forceSSL = true;
        useACMEHost = vars.domain;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://192.168.178.186:${toString config.nixarr.radarr.port}";
        };
      };

      "sonarr.${vars.domain}" = {
        forceSSL = true;
        useACMEHost = vars.domain;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://192.168.178.186:${toString config.nixarr.sonarr.port}";
        };
      };

      "transmission.${vars.domain}" = {
        forceSSL = true;
        useACMEHost = vars.domain;
        locations."/" = {
          proxyPass = "http://192.168.178.186:${toString config.nixarr.transmission.uiPort}";
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
