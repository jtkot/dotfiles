{
  config,
  pkgs,
  lib,
  ...
}:
let
  mkSystemBinSymlink =
    path:
    pkgs.runCommandLocal "${lib.baseNameOf path}-system-bin-symlink" { } ''
      	mkdir -p $out/bin
      	ln -s ${path} $out/bin/
      	'';
in
{
  system.primaryUser = "jan";
  system.tools = {
    darwin-option.enable = false;
    darwin-uninstaller.enable = false;
    darwin-version.enable = false;
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

    shells = [ pkgs.bashInteractive ];
    defaultPackages = [
      (mkSystemBinSymlink "/usr/libexec/PlistBuddy")
      (mkSystemBinSymlink "/usr/libexec/java_home")
      (mkSystemBinSymlink "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister")
    ];
  };
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };
}
