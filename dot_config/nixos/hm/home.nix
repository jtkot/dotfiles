{ pkgs, ... }:
{
  home.username = "jan";
  home.homeDirectory = "/home/jan";

  home.stateVersion = "25.11";
  home.packages = with pkgs; [
    bintools
    bottom
    cider-2
    chezmoi
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
    intel-one-mono
    imagemagick
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
    patchelf
    pandoc
    qview
    pax-utils
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
