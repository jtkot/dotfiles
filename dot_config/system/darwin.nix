{
  pkgs,
  lib,
  ...
}:
{
  users = {
    users.root = {
      shell = pkgs.bashInteractive;
      uid = 0;
      gid = 0;
    };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
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
