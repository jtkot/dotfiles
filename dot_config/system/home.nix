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
    homeDirectory =
      (if pkgs.stdenv.hostPlatform.isDarwin then "/Users/" else "/home/") + config.home.username;

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
        python3.pkgs.mutagen
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
        loupe
        llama-cpp-vulkan
        mpv # programs
        nur.repos.Ev357.helium
        qt6.qtdeclarative
        widevine-cdm
      ];
  };

  fonts.fontconfig.enable = !pkgs.stdenv.hostPlatform.isDarwin;
  programs.nix-index.symlinkToCacheHome = false;
  systemd.user.enable = false;
  xdg.userDirs = {
    enable = !pkgs.stdenv.hostPlatform.isDarwin;
    createDirectories = true;
    templates = null;
    projects = null;
    videos = "${config.home.homeDirectory}/Movies";
  };

  targets.darwin = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
    linkApps.enable = true;
    copyApps.enable = !config.targets.darwin.linkApps.enable;
    defaults = {
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
    };
  };
}
