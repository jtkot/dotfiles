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
            version = "595.80";
            sha256_64bit = "sha256-PVTIP+B/01c/8M66hXTAYTLg9T2Hy9u1gq43K7TF1Hg=";
            openSha256 = "sha256-nonwYYPItHeMC/5Ox/TlWhjiddMPu4PLqNhgIg+bfW8=";
            settingsSha256 = "sha256-AtzYTz7kbmj3vxmBQTC0eAjM3b2I259y1tdxq90n9YU=";
            persistencedSha256 = "sha256-WL57kKFWeRW0oPktp6afkUb5Om9MCGAvKWctk5yiyIA=";
          };
        }
      );
    }
  );
}
