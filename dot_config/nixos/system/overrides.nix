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
            version = "595.84";
            sha256_64bit = "sha256-mcQE5SExvye8ptoCaNzOPr7cenOrF0BxqZXPGmxeugY=";
            sha256_aarch64 = "sha256-GloNdDFfmXFVu4FAlNNk2qzqLOuw2N5CKatKkcSrQxk=";
            openSha256 = "sha256-pEmA2tUcOKwUPKy6N0QvS49Pdut4/7Phs/JhjdyBcNY=";
            settingsSha256 = "sha256-QrnBM+sdWO4GanO62rxpHmRrjYkYpl5RD6fIiHq4C4A=";
            persistencedSha256 = "sha256-50xYdgx7EEThbaMp4QS8GADbxj0mhBXh8QQN0tWMwRg=";
          };
        }
      );
    }
  );
}
