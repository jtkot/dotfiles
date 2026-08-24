{
  nixpkgs-unstable ? null,
}:
final: prev:
let
  lib = final.lib;
  selectHighestVersion = a: b: if lib.versionOlder a.version b.version then b else a;
in
{
  ghidra = prev.ghidra.overrideAttrs (with final;
    finalGhidra: prevGhidra: {
      passthru = prevGhidra.passthru // {
        withExtensions =
          f:
          (symlinkJoin {
            name = "${ghidra.pname}-with-extensions-${lib.getVersion final.ghidra}";
            paths = (f ghidra-extensions);
            nativeBuildInputs = [
              makeBinaryWrapper
            ]
            ++ lib.optional stdenv.hostPlatform.isDarwin final.desktopToDarwinBundle;
            postBuild = ''
              # Prevent attempted creation of plugin lock files in the Nix store.
              touch $out/lib/ghidra/Ghidra/.dbDirLock

              makeWrapper "${ghidra}/lib/ghidra/ghidraRun" "$out/bin/ghidra" \
                  --set NIX_GHIDRAHOME "$out/lib/ghidra/Ghidra"
              for bin in ${ghidra}/lib/ghidra/support/*; do
                    if [[ ! -d $bin ]] && [[ -x $bin ]]; then
                      makeWrapper "$bin" "$out/bin/ghidra-$(basename "$bin")" \
                        --set NIX_GHIDRAHOME "$out/lib/ghidra/Ghidra" \
						--prefix PATH : ${lib.makeBinPath [ python3 openjdk21 ]}
                    fi
                  done
              ln -s ${ghidra}/share $out/share
            '';
            inherit (ghidra) meta;
          });
      };
    }
  );

  ghidra-mcp = final.ghidra.buildGhidraExtension (
    let
      version = "6.0.0";
    in
    {
      pname = "ghidra-mcp";
      inherit version;

      src = final.fetchFromGitHub {
        owner = "bethington";
        repo = "ghidra-mcp";
        rev = "v${version}";
        hash = "sha256-LnhhJwycO8NQV+YaTP7ZoxGkoGLkc14BwY66wczbpp0=";
      };

      installPhase = ''
        runHook preInstall

        mkdir -p $out/lib/ghidra/Ghidra/Extensions
        unzip -d $out/lib/ghidra/Ghidra/Extensions build/distributions/*.zip

        # Prevent attempted creation of plugin lock files in the Nix store.
        for i in $out/lib/ghidra/Ghidra/Extensions/*; do
          touch "$i/.dbDirLock"
        done

        runHook postInstall
      '';

      meta = {
        description = "Ghidra MCP Server";
        homepage = "https://github.com/bethington/ghidra-mcp";
        license = lib.licenses.asl20;
      };
    }
  );
  license-cli = prev.license-cli.overrideAttrs (
    finalAttrs: prevAttrs: {
      postInstall = ''
        installShellCompletion completions/license.{bash,fish}
        installShellCompletion --zsh completions/_license
        installManPage ./license.1

        install -Dm0755 ./scripts/set-license -t $out/bin
        wrapProgram $out/bin/set-license \
          --prefix PATH : "$out/bin" \
          --prefix PATH : ${lib.makeBinPath [ final.fzf ]}
      ''
      + lib.optionalString (!final.stdenv.isDarwin) ''

        install -Dm0755 ./scripts/copy-header -t $out/bin
        wrapProgram $out/bin/copy-header \
          --prefix PATH : "$out/bin" \
          --prefix PATH : ${
            lib.makeBinPath (
              with final;
              [
                wl-clipboard
                xclip
              ]
            )
          }
      '';
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
