{
  lib,
  pkgs,
  ...
}:
{
  system.disableInstallerTools = true;

  # Workaround for Unreal Engine
  system.activationScripts.binBash = {
    text = ''
      ln -sfn /bin/sh /bin/bash
    '';
  };

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 0;
    plymouth.enable = true;
    tmp.cleanOnBoot = true;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];
    kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  zramSwap = {
    enable = true;
    memoryMax = 16 * 1024 * 1024 * 1024;
  };

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.firewall.enable = false;
  services.avahi.enable = true;
  services.resolved.enable = true;
  services.resolved.settings.Resolve.DNSOverTLS = true;
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];

  hardware.enableAllFirmware = true;
  hardware.graphics.enable = true;
  hardware.keyboard.qmk.enable = true;
  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.fwupd.enable = true;
  services.gvfs.enable = true;
  services.printing.enable = true;
  services.scx.enable = true;
  services.timesyncd.servers = [ "time.apple.com" ];
  services.upower.enable = true;
  services.usbmuxd.enable = true;
  services.userborn.enable = true;
  virtualisation.containers.enable = true;

  i18n.defaultLocale = "pl_PL.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  users = {
    defaultUserShell = pkgs.bashInteractive;
    groups.jan = { };
    users.jan = {
      description = "Jan Kot";
      isNormalUser = true;
      group = "jan";
      extraGroups = [
        "wheel"
        "plugdev"
      ];
    };
  };

  fonts.packages = with pkgs; [ nerd-fonts.symbols-only ];
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    apple-cursor
    brightnessctl
    ddcutil
    efibootmgr
    file
    ghostty
    grim
    hyprpolkitagent
    jq
    nautilus
    quickshell
    sbctl
    slurp
    walker
    wl-clipboard
  ];

  programs.nano.enable = false;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };

  programs.gnome-disks.enable = true;
  programs.hyprlock.enable = true;
  services.displayManager.gdm.enable = true;
  services.elephant.enable = true;
  services.gnome.sushi.enable = true;
  services.hypridle.enable = true;
  services.playerctld.enable = true;
  services.xserver.xkb.layout = "pl";
  services.pipewire = {
    enable = true;
    audio.enable = true;
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.dconf.profiles = {
    gdm.databases = [
      {
        settings = with lib.gvariant; {
          "org/gnome/desktop/interface" = {
            scaling-factor = mkUint32 1;
            cursor-theme = mkString "macOS";
          };
        };
      }
    ];
  };

  systemd.user.services.hypridle.serviceConfig.Slice = "session.slice";
  systemd.user.services.hyprpolkitagent = {
    description = "hyprpolkitagent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  systemd.user.services.elephant = {
    enableDefaultPath = false;
    serviceConfig = {
      Slice = "session.slice";
    };
  };
  systemd.user.services.quickshell = {
    description = "Quickshell";
    documentation = [ "https://quickshell.outfoxxed.me/docs" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "wayland-wm@hyprland.desktop.service" ];
    enableDefaultPath = false;
    serviceConfig = {
      ExecStart = "${pkgs.quickshell}/bin/qs";
      Restart = "on-failure";
      Slice = "session.slice";
    };
  };
  systemd.user.services.walker-daemon = {
    description = "Walker - Multi-Purpose Launcher (background service)";
    documentation = [ "https://benz.gitbook.io/walker" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "wayland-wm@hyprland.desktop.service" ];
    enableDefaultPath = false;
    serviceConfig = {
      ExecStart = "${pkgs.walker}/bin/walker --gapplication-service";
      Restart = "on-failure";
      Slice = "session.slice";
    };
  };
}
