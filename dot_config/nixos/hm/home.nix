{ pkgs, ... }:
{
  home.username = "jan";
  home.homeDirectory = "/home/jan";

  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    bintools
    bottom
    chezmoi
    cider-2
    d-spy
    fastfetch
    file
    fzf
    gdb
    gh
    ghostty
    gimp
    git
    googlesans-code
    imagemagick
    intel-one-mono
    jq
    jujutsu
    license-cli
    llama-cpp-vulkan
    mpv
    neovim
    nix-tree
    nixd
    nixfmt
    nur.repos.Ev357.helium
    opencode
    p7zip
    pandoc
    patchelf
    pax-utils
    qview
    qt6.qtdeclarative
    ripgrep
    rtk
    texliveSmall
    tmux
    unzip
    vscode-langservers-extracted
    widevine-cdm
    yq
    yt-dlp
    zbar
  ];

  fonts.fontconfig.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true; # is it necessary?
  };
}
