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
    imagemagick
    jq
    jujutsu
    license-cli
    llama-cpp-vulkan
    mpv
    neovim
    nix-index
    nix-tree
    nixd
    nixfmt
    nur.repos.Ev357.helium
    p7zip
    patchelf
    qview
    pax-utils
    ripgrep
    tmux
    unzip
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
