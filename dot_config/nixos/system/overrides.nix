final: prev: {
  openrgb = prev.openrgb.overrideAttrs (
    prevAttrs:
    let
      rev = "8afad91b33f5fc61f632fe67b6ca98fe2299613d";
    in
    {
      version = "0.9.1.g${builtins.substring 0 8 rev}";
      src = final.fetchgit {
        inherit rev;
        url = "https://gitlab.com/CalcProgrammer1/OpenRGB.git";
        fetchTags = true;
        hash = "sha256-3geSs/xePJEXNxzspakP6kUhgtzA0lcHYrvwN7lGFWc=";
      };
      nativeBuildInputs = prevAttrs.nativeBuildInputs ++ (with final; [ git ]);
      patches = [ ];
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
