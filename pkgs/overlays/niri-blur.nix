{ inputs, ... }:
final: prev: {
  niri = prev.niri.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "niri-wm";
      repo = "niri";
      rev = "581b5be093b983a9a2911c5f45e6bda2e87fe574";
      hash = "sha256-KIbF/TPvHu4oH9qQlUNDBAzpMuo8ptek6Wbxrz61SA4=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit (old) pname version;
      src = prev.fetchFromGitHub {
        owner = "niri-wm";
        repo = "niri";
        rev = "581b5be093b983a9a2911c5f45e6bda2e87fe574";
        hash = "sha256-KIbF/TPvHu4oH9qQlUNDBAzpMuo8ptek6Wbxrz61SA4=";
      };
      hash = "sha256-soJYT6TavlyqtVqMD70QYDZ+8swn6TVXsFHadJxaxWo=";
    };
    postPatch = ''
      substituteInPlace resources/niri.service \
        --replace-warn "/usr/bin" ""  || true
    '';
  });
}
# final: prev: {
#   niri = prev.niri.overrideAttrs (old: {
#     src = prev.fetchFromGitHub {
#       owner = "niri-wm";
#       repo  = "niri";
#       rev   = "wip/branch";
#       hash  = "sha256-...";
#     };
#     postPatch = ''
#       substituteInPlace resources/niri.service \
#         --replace-warn "/usr/bin" ""  || true
#     '';
#   });
# }
