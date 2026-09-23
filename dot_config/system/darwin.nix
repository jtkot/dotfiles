{
  pkgs,
  lib,
  ...
}:
{
  system.primaryUser = "jan";
  system.tools.enable = false;
  system.tools.darwin-rebuild.enable = true;

  users = {
    knownUsers = [
      "root"
      "jan"
    ];
    users.root = {
      shell = pkgs.bashInteractive;
      uid = 0;
      gid = 0;
    };
    users.jan = {
      description = "Jan Kot";
      shell = pkgs.bashInteractive;
      uid = 501;
      gid = 20;
      isHidden = false;
    };
  };

  environment = {
    extraInit = ''
      # source: https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/setup.sh
      addToSearchPath() {
        local varName="$1"
        local dir="$2"
        if [[ -d "$dir" && "''${!varName:+:''${!varName}:}" \
          != *":''${dir}:"* ]]; then
          export "''${varName}=''${!varName:+''${!varName}:}''${dir}"
        fi
      }

      # WORKAROUND: see https://github.com/nix-darwin/nix-darwin/issues/391
      for file in /etc/paths /etc/paths.d/*; do
        while read dir; do addToSearchPath "PATH" "$dir"; done < "$file"
      done

      for file in /etc/manpaths /etc/manpaths.d/*; do
        while read dir; do addToSearchPath "MANPATH" "$dir"; done < "$file"
      done
    '';

    shells = [ pkgs.bashInteractive ];
    pathsToLink = [ "/share/vulkan" ];
    variables = {
      HOMEBREW_NO_ANALYTICS = "1";
      HOMEBREW_NO_ASK = "1";
      HOMEBREW_NO_EMOJI = "1";
      HOMEBREW_NO_ENV_HINTS = "1";
      XDG_DATA_DIRS = [
        "/Applications/Xcode.app/Contents/Developer/usr/share"
      ];
    };
    systemPackages = with pkgs; [
      mesa-unstable
    ];
  };
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  homebrew = {
    enable = true;
    enableBashIntegration = true;
    casks = [
      "ableton-live-suite"
      "calibre"
      "db-browser-for-sqlite"
      "game-porting-toolkit"
      "ghostty"
      "helium-browser"
      "imhex"
      "moonlight"
      "schism-tracker"
      "secretive"
      "stolendata-mpv"
      "transmission"
      "valhalla-freq-echo"
      "valhalla-space-modulator"
      "valhalla-supermassive"
      "wireshark-app"
    ];
    masApps = {
      # "GREE+" = 1167857672;
      # "Hik-Connect" = 1087803190;
      "Keynote" = 361285480;
      "MacPacker" = 6473273874;
      "Microsoft Excel" = 462058435;
      "Model D" = 1339418001;
      "Pages" = 361309726;
      "Pixelmator Pro" = 1289583905;
      "Reeder" = 6475002485;
      "WireGuard" = 1451685025;
      "Xcode" = 497799835;
    };
    taps = [
      {
        name = "gcenx/wine";
        trusted = true;
      }
      {
        name = "bell-sw/liberica";
        trusted = true;
      }
    ];
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;
  };

  system.defaults = {
    CustomSystemPreferences = {
      "/Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist" = {
        AutoHotspotMode = "Never";
        JoinModeFallback = [ "DoNothing" ];
      };
      "/Library/Preferences/.GlobalPreferences.plist" = {
        "com.apple.coremedia.optimizeVideoStreamingOnBattery" = true;
      };
      loginwindow = {
        RetriesUntilHint = 0;
      };
      system.defaults.SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = true;
        AutomaticDownload = true;
        SplatEnabled = true;
      };
    };
  };
}
