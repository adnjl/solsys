{ inputs }:
[
  (final: prev: {
    niri = prev.niri.overrideAttrs (old: {
      doCheck = false;
      checkPhase = "true";
    });
  })
  # (import ./niri-blur.nix { inherit inputs; })
]
