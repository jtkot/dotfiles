{
  pkgs,
  inputs,
  ...
}:
{
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ (import ./overrides.nix { nixpkgs-unstable = inputs.nixpkgs-unstable; }) ];
  };

  security.sudo.extraConfig = "Defaults pwfeedback";
  time.timeZone = "Europe/Warsaw";
  documentation.doc.enable = false;
  documentation.info.enable = false;

  environment.shellAliases = {
    rm = "rm -i";
    cp = "cp -i";
    mv = "mv -i";
    sudo = "sudo ";
  };

  environment.systemPackages = with pkgs; [
    nh # programs (nixos only)
  ];
  programs.zsh.enable = false;
  programs.bash.completion.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
