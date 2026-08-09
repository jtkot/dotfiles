{
  nixpkgs-unstable ? null,
}:
final: prev:
let
  lib = final.lib;
  selectHighestVersion = a: b: if lib.versionOlder a.version b.version then b else a;
in
{
    }
  );
  kernelPackagesExtensions = prev.kernelPackagesExtensions ++ [
    (_: prevKernelPackages: {
      nvidiaPackages = prevKernelPackages.nvidiaPackages.extend (
        finalNvidiaPackages: _:
        (lib.genAttrs [ "new_feature" "production" ] (
          branch:
          finalNvidiaPackages.mkDriver (
            with nixpkgs-unstable.legacyPackages.x86_64-linux.linuxPackages.nvidiaPackages.${branch};
            {
              inherit version;
              sha256_64bit = modsrc.src.hash;
              sha256_aarch64 =
                nixpkgs-unstable.legacyPackages.aarch64-linux.linuxPackages.nvidiaPackages.${branch}.modsrc.src.hash;
              openSha256 = open.src.hash;
              settingsSha256 = settings.src.hash;
              persistencedSha256 = persistenced.src.hash;
            }
          )
        ))
        // (with finalNvidiaPackages; {
          stable = if final.stdenv.hostPlatform.system == "i686-linux" then legacy_390 else production;
          latest = selectHighestVersion production new_feature;
          bleeding_edge = latest;
        })
      );
    })
  ];
}
