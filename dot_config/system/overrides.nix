{
  nixpkgs-unstable ? null,
}:
final: prev:
let
  lib = final.lib;
  selectHighestVersion = a: b: if lib.versionOlder a.version b.version then b else a;
in
{
  ani-cli =
    (prev.ani-cli.overrideAttrs (
      finalAttrs: prevAttrs: {
        version = "4.15";
        src = final.fetchFromGitHub {
          owner = "pystardust";
          repo = "ani-cli";
          tag = "v${finalAttrs.version}";
          hash = "sha256-rF432mMBRaOSTk3+bsxR2NnaG0ATOdQ3ddQ13B85spc=";
        };
        runtimeInputs = prevAttrs.runtimeInputs ++ (with final; [ botan3 ]);
      }
    )).override
      { withMpv = false; };
  openrgb = prev.openrgb.overrideAttrs (
    prevAttrs:
    let
      rev = "bfccc1a95d6ed1325d9f9203533ed887e2bffd33";
    in
    {
      version = "0.9.1.g${builtins.substring 0 8 rev}";
      src = final.fetchgit {
        inherit rev;
        url = "https://gitlab.com/CalcProgrammer1/OpenRGB.git";
        fetchTags = true;
        hash = "sha256-6pWroBrqAiy+yP+HgVnpyA2qpDc+1F42/dRw87ICDts=";
      };
      nativeBuildInputs = prevAttrs.nativeBuildInputs ++ (with final; [ git ]);
      patches = [ ];
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
