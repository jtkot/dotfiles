{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs = {
    overlays = with inputs; [
      nur.overlays.default
      (import ./overrides.nix { })
    ];
    config.allowUnfree = true;
  };

  home = {
    stateVersion = "26.05";
    username = "jan";
    homeDirectory = (if pkgs.stdenv.isDarwin then "/Users/" else "/home/") + config.home.username;

    packages =
      with pkgs;
      [
        (ani-cli.override { withMpv = false; })
        apkeep
        ascii-image-converter
        binwalk
        bottom # programs
        chezmoi
        cloudflared
        djvulibre
        efm-langserver
        fastfetch # programs
        fd # programs
        ffmpeg
        forgejo-cli
        fzf # programs
        gh # programs
        ghidra
        git-lfs # programs
        imagemagick
        intel-one-mono
        jadx
        jujutsu # programs
        kaitai-struct-compiler
        license-cli
        lima
        loccount
        lua-language-server
        mutagen
        neovim # programs
        nix-prefetch-scripts
        nix-tree
        nixd
        nixfmt
        nmap
        ocamlPackages.cpdf
        oci-cli
        opencode # programs
        p7zip-rar
        pandoc # programs
        podman # services
        podman-compose
        portablemc
        recode
        ripgrep # programs
        roboto
        rtk
        ruby_4_0
        ruffle
        shfmt
        shellcheck
        sshuttle
        stylua
        tmux # programs
        tombi
        typst
        validator-nu
        vscode-langservers-extracted
        yaml-language-server
        yq-go
        yt-dlp # programs
        zbar
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
        blender
        cider-2
        d-spy
        gdb
        ghostty # programs
        imhex
        krita
        llama-cpp-vulkan
        mpv # programs
        nur.repos.Ev357.helium
        qt6.qtdeclarative
        qview
        widevine-cdm
      ];
  };

  fonts.fontconfig.enable = !pkgs.stdenv.isDarwin;
  xdg.userDirs = {
    enable = !pkgs.stdenv.isDarwin;
    createDirectories = true;
    templates = null;
    projects = null;
    videos = "${config.home.homeDirectory}/Movies";
  };
  programs.nix-index.symlinkToCacheHome = false;
  targets.darwin = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkApps.enable = true;
    copyApps.enable = !config.targets.darwin.linkApps.enable;
    defaults = {
      NSGlobalDomain = {
        "com.apple.sound.beep.feedback" = true;
        "com.apple.sound.beep.sound" = "/System/Library/Sounds/Bottle.aiff";
        AppleSpacesSwitchOnActivate = true;
        NSCloseAlwaysConfirmsChanges = true;
        NSQuitAlwaysKeepsWindows = true;
        NSWindowShouldDragOnGesture = true;
        NSZoomButtonShowMenu = false;

        # Mouse/Trackpad
        "com.apple.swipescrolldirection" = 1;
        CGDisableCursorLocationMagnification = true;

        # Keyboard
        NSAutomaticCapitalizationEnabled = false;
        WebAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        InitialKeyRepeat = 25;
        KeyRepeat = 2;
        ApplePressAndHoldEnabled = false;
      };
      "com.apple.bird" = {
        "com.apple.clouddocs.unshared.moveOut.suppress" = 1;
      };
      "com.apple.chronod" = {
        effectiveRemoteWidgetsEnabled = false;
        hasRemoteWidgets = false;
      };
      "com.apple.dock" = {
        tilesize = 36;
        largesize = 72;
        magnification = true;
        enterMissionControlByTopWindowDrag = false;
        expose-group-apps = true;
        mru-spaces = false;
        show-recents = false;
      };
      "com.apple.finder" =
        let
          IconViewSettings = {
            arrangeBy = "name";
            backgroundColorBlue = 1;
            backgroundColorGreen = 1;
            backgroundColorRed = 1;
            gridOffsetX = 0;
            gridOffsetY = 0;
            gridSpacing = 44;
            iconSize = 64;
            labelOnBottom = true;
            showIconPreview = true;
            showItemInfo = true;
            textSize = 11;
          };
        in
        {
          FK_DefaultIconViewSettings = IconViewSettings;
          FXDefaultSearchScope = "SCcf"; # current directory
          FXEnableExtensionChangeWarning = false;
          FXICloudDriveDesktop = true;
          FXICloudDriveDocuments = true;
          FXICloudDriveEnabled = true;
          FXPreferredGroupBy = "None";
          FXPreferredViewStyle = "icnv";
          FXRemoveOldTrashItems = true;
          FinderSpawnTab = false;
          NewWindowTarget = "PfHm"; # home directory
          ShowHardDrivesOnDesktop = false;
          ShowPathbar = true;
          _FXSortFoldersFirst = true;
          _FXSortFoldersFirstOnDesktop = true;
          DesktopViewSettings = {
            IconViewSettings = IconViewSettings // {
              arrangeBy = "grid";
              showItemInfo = false;
            };
          };
          ICloudViewSettings = {
            inherit IconViewSettings;
          };
          StandardViewSettings = {
            inherit IconViewSettings;
          };
        };
      "com.apple.loginwindow" = {
        ClockFontIdentifier = "rounded";
        ClockFontWeight = 485;
        TALLogoutSavesState = false;
      };
      "com.apple.menuextra.clock" = {
        FlashDateSeparators = false;
        ShowDate = 1;
        ShowDayOfWeek = true;
        ShowSeconds = true;
      };
      "com.apple.screencapture" = {
        disable-shadow = true;
        location-screenshot = "~/Library/Mobile Documents/com~apple~CloudDocs/Zrzuty ekranu";
        location-screenrecording = "~/Library/Mobile Documents/com~apple~CloudDocs/Nagrania ekranu";
        save-selections = false;
        show-thumbnail = true;
        showsCursor = true;
        captureSystemAudio = true;
        style = "selection";
      };
      "com.apple.WindowManager" = {
        # Window tiling
        EnableTilingByEdgeDrag = false;
        EnableTopTilingByEdgeDrag = false;
        EnableTilingOptionAccelerator = true;

        # Stage Manager
        AppWindowGroupingBehavior = 0;
        GloballyEnabledEver = true;

        # Desktop
        EnableStandardClickToShowDesktop = false;
      };
      "com.apple.TextEdit" = {
        NSShowAppCentricOpenPanelInsteadOfUntitledFile = false;
        RichText = false;
        CheckGrammarWithSpelling = true;
        NSFixedPitchFontSize = 17;
      };
      "${config.home.homeDirectory}/Library/Containers/com.apple.archiveutility/Data/Library/Preferences/com.apple.archiveutility.plist" =
        {
          dearchive-move-after-location.Selection = "MoveToTrash";
          archive-reveal-after = true;
        };
    };
  };
}
