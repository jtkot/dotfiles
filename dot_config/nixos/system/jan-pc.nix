{
  config,
  lib,
  ...
}:
{
  imports = [ ./base.nix ];
  networking.hostName = "jan-pc";
  services.openssh.enable = true;
  services.displayManager.gdm.autoSuspend = false;

  networking.networkmanager.wifi.powersave = false;
  networking.wireless.iwd.settings = {
    DriverQuirks = {
      PowerSaveDisable = "?*";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.bluetooth.enable = true;
  services.hardware.openrgb.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    nvidiaSettings = false;
    powerManagement.enable = true;
  };

  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [ nct6687d ];
  boot.kernelModules = [
    "kvm-intel"
    "nct6687"
  ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/1a1bb588-b80b-47be-b469-3f97dc05f1ba";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=root"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/1a1bb588-b80b-47be-b469-3f97dc05f1ba";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=home"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/1a1bb588-b80b-47be-b469-3f97dc05f1ba";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=nix"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/59D7-B538";
      fsType = "vfat";
      options = [
        "umask=0077"
      ];
    };
  };
}
