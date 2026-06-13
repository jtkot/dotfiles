{
  lib,
  pkgs,
  ...
}:
{
  system.stateVersion = lib.versions.majorMinor lib.version;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ (import ./overrides.nix) ];
  };
  documentation.nixos.enable = false;

  # Workaround for Unreal Engine
  system.activationScripts.binbash = {
    text = ''
      ln -sfn /bin/sh /bin/bash
    '';
  };

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "udev.log_level=3"
  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.plymouth.enable = true;

  security.polkit.enable = true;
  security.rtkit.enable = true;
  security.sudo.extraConfig = "Defaults pwfeedback";

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "pl_PL.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  users.users.jan = {
    description = "Jan Kot";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "plugdev"
    ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    brightnessctl
    apple-cursor
    ghostty
    grim
    hyprlock
    hyprpolkitagent
    hypridle
    nautilus
    nh
    sbctl
    slurp
    sushi
    elephant
    walker
    wl-clipboard
    quickshell
  ];
  fonts.packages = [ pkgs.font-awesome ];

  hardware.keyboard.qmk.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;

  programs.fish.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.nix-ld.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.gnome-disks.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.firewall.enable = false;
  services.resolved.enable = true;

  services.dbus.implementation = "broker";
  services.flatpak.enable = true;
  services.fwupd.enable = true;
  services.gvfs.enable = true;
  services.playerctld.enable = true;
  services.timesyncd.servers = [ "time.apple.com" ];
  services.printing.enable = true;
  services.upower.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
  };
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [ xterm ];
    xkb.layout = "pl";
  };
  services.displayManager.gdm.enable = true;
  programs.dconf.profiles = {
    gdm.databases = [
      {
        settings = with lib.gvariant; {
          "org/gnome/desktop/interface" = {
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
  zramSwap.enable = true;
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };
  zramSwap.memoryMax = 16 * 1024 * 1024 * 1024;
}
