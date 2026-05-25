final: prev: {
  openrgb-beta = prev.openrgb.overrideAttrs (
    old:
    let
      commit = "a6b890a48d75325d47587131c74764b8e9a06a53";
    in
    {
      version = builtins.substring 0 8 commit;
      src = final.fetchFromGitLab {
        owner = "CalcProgrammer1";
        repo = "OpenRGB";
        rev = commit;
        hash = "sha256-54rkkwgxLOseRJru3RkX2aYE6y4ryzFUCHR423+Ni/I=";
      };
      patches = [ ];
      postPatch = ''
        patchShebangs scripts/build-udev-rules.sh
        substituteInPlace scripts/build-udev-rules.sh --replace-fail "/usr/bin/env chmod" "${final.coreutils}/bin/chmod"
      '';
    }
  );
  linuxPackages = prev.linuxPackages.extend (
    lpself: lpsuper: {
      nvidiaPackages = lpsuper.nvidiaPackages.extend (
        npself: npsuper: {
          stable = npself.mkDriver {
            version = "595.71.05";
            sha256_64bit = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
            sha256_aarch64 = "sha256-XzKloS00dFKTd4ATWkTIhm9eG/OzR/Sim6MboNZWPu8=";
            openSha256 = "sha256-Lfz71QWKM6x/jD2B22SWpUi7/og30HRlXg1kL3EWzEw=";
            settingsSha256 = "sha256-mXnf3jyvznfB3OfKd657rxv0rYHQb/dX/Riw/+N9EKU=";
            persistencedSha256 = "sha256-Z/6IvEEa/XfZ5F5qoSIPvXJLGtscYVqjFxHZaN/M2Ts=";
          };
        }
      );
    }
  );
}
