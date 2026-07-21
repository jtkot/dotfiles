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
      (import ./overrides.nix)
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
        ani-cli
        apkeep
        ascii-image-converter
        binwalk
        bottom
        chezmoi
        cloudflared
        djvulibre
        efm-langserver
        fastfetch
        fd
        ffmpeg
        forgejo-cli
        fzf
        gh
        ghidra-bin
        git-lfs
        gitMinimal
        imagemagick
        intel-one-mono
        jadx
        jujutsu
        kaitai-struct-compiler
        lima
        loccount
        lua-language-server
        mutagen
        neovim
        nix-prefetch-scripts
        nix-tree
        nixd
        nixfmt
        nmap
        ocamlPackages.cpdf
        oci-cli
        opencode
        p7zip
        pandoc
        podman
        podman-compose
        portablemc
        recode
        ripgrep
        roboto
        rtk
        ruby_4_0
        ruffle
        shellcheck
        sshuttle
        stylua
        tmux
        tombi
        typst
        validator-nu
        vscode-langservers-extracted
        yaml-language-server
        yq
        yt-dlp
        zbar
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
        blender
        cider-2
        d-spy
        gdb
        ghostty
        krita
        license-cli
        llama-cpp-vulkan
        mpv
        nur.repos.Ev357.helium
        qt6.qtdeclarative
        qview
        widevine-cdm
      ];
  };

  fonts.fontconfig.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    templates = null;
    projects = null;
    videos = "${config.home.homeDirectory}/Movies";
  };

  targets.darwin = lib.optionalAttrs pkgs.stdenv.isDarwin {
    defaults = {
      NSGlobalDomain = {
        "com.apple.sound.beep.feedback" = true;
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
      "com.apple.finder" = {
        FXEnableExtensionChangeWarning = false;
        _FXSortFoldersFirst = true;
        _FXSortFoldersFirstOnDesktop = true;
        FXDefaultSearchScope = "SCcf"; # current directory
        NewWindowTarget = "PfHm"; # home directory
        FinderSpawnTab = false;
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
      "com.apple.WindowManager" = {
        # Window tiling
        EnableTilingByEdgeDrag = false;
        EnableTopTilingByEdgeDrag = false;
        EnableTilingOptionAccelerator = true;

        # Stage Manager
        AppWindowGroupingBehavior = 0;

        # Desktop
        EnableStandardClickToShowDesktop = false;
      };
      "com.apple.screencapture" = {
        disable-shadow = true;
        location = "~/Library/Mobile Documents/com~apple~CloudDocs/Zrzuty ekranu";
        save-selections = false;
        show-thumbnail = true;
        showsCursor = true;
        style = "selection";
      };
      "com.apple.menuextra.clock" = {
        FlashDateSeparators = false;
        ShowDate = 1;
        ShowDayOfWeek = true;
        ShowSeconds = true;
      };
    };
  };
}
