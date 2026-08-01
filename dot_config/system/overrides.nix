final: prev: {
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
      rev = "c7140baa330dabce7c699c418cc0963f17f32202";
    in
    {
      version = "0.9.1.g${builtins.substring 0 8 rev}";
      src = final.fetchgit {
        inherit rev;
        url = "https://gitlab.com/CalcProgrammer1/OpenRGB.git";
        fetchTags = true;
        hash = "sha256-JNVAefH87I/ni+RKVvJU+LNvgzNTjuR1G9J/Di3gwsE=";
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
            version = "610.43.03";
            sha256_64bit = "sha256-ReLUwTSiPDXlDyU6SqY+fl6NF+PRhdSgfIpY6WEu05I=";
            sha256_aarch64 = "sha256-jSdlXo60ilXLKWKvZfgbBnVqVYuw6zhnGuiDgwxYz94=";
            openSha256 = "sha256-QCXmqo2xNyIwjGv0da2MUC8ex641Mmc5DUI+uRFVwgE=";
            settingsSha256 = "sha256-z/t+SdEQdVJPwjKIRHO02d264Kt47eWiOwwsaxmh4xQ=";
            persistencedSha256 = "sha256-sOKUsAFHh0/COH+nNgbH9+7hWgivOzq4YmTuk9MOFfI=";
          };
        }
      );
    }
  );
  net-usb-kernel-modules =
    let
      kernel = final.linuxPackages_7_1.kernel;
    in
    final.stdenv.mkDerivation {
      pname = "net-usb-kernel-modules";
      inherit (kernel)
        src
        version
        postPatch
        nativeBuildInputs
        ;

      kernel_dev = kernel.dev;
      kernelVersion = kernel.modDirVersion;

      modulePath = "drivers/net/usb";

      buildPhase = ''
        runHook preBuild

        make -C "$kernel_dev/lib/modules/$kernelVersion/build" \
        M="$PWD/$modulePath" \
        "-j$NIX_BUILD_CORES" \
        modules

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        make -C "$kernel_dev/lib/modules/$kernelVersion/build" \
           INSTALL_MOD_PATH="$out" \
           XZ="xz -T$NIX_BUILD_CORES" \
           M="$PWD/$modulePath" \
           modules_install

        runHook postInstall
      '';
    };
}
