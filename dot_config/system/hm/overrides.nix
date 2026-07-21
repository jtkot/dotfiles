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
}
