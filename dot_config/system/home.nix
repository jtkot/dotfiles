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
        yq
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
