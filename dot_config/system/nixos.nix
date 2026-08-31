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

  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
  hardware.keyboard.qmk.enable = true;
  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.fwupd.enable = true;
  services.gvfs.enable = true;
  services.printing.enable = true;
  services.timesyncd.servers = [ "time.apple.com" ];
  services.upower.enable = true;
  services.userborn.enable = true;
  services.usbmuxd.enable = true;
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

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    apple-cursor
    # brightnessctl
    ddcutil
    efibootmgr
    elephant # available also as a service
    file
    ghostty
    gitMinimal # available in programs
    grim
    hypridle # services
    hyprlock # services
    hyprpolkitagent
    jq
    nautilus
    quickshell
    sbctl
    slurp
    sushi # services
    walker
    wl-clipboard
  ];

  fonts.packages = with pkgs; [ nerd-fonts.symbols-only ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  services.pipewire = {
    enable = true;
    audio.enable = true;
  };

  programs.nano.enable = false;
  programs.gnome-disks.enable = true;
  services.displayManager.gdm.enable = true;
  services.playerctld.enable = true;
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [ xterm ];
    xkb.layout = "pl";
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
}
