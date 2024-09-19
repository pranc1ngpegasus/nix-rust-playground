{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix.url = "github:nix-community/fenix/monthly";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    fenix,
    pre-commit-hooks,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        toolchain = fenix.packages.${system}.fromToolchainFile {
          file = ./rust-toolchain.toml;
          sha256 = "sha256-VZZnlyP69+Y3crrLHQyJirqlHrTtGTsyiSnZB8jEvVo=";
        };
        checks = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra = {
              enable = true;
              entry = "alejandra .";
              files = "^.*\\.nix$";
              language = "system";
              pass_filenames = false;
            };
            clippy = {
              enable = true;
              files = "^.*\\.rs";
              pass_filenames = false;
              packageOverrides.cargo = toolchain;
              packageOverrides.clippy = toolchain;
              settings.allFeatures = true;
            };
            taplo = {
              enable = true;
              entry = "taplo format .";
              files = "^.*\\.toml";
              language = "system";
              pass_filenames = false;
            };
          };
        };
      in {
        devShells.default = pkgs.stdenv.mkDerivation {
          name = "nix-rust-playground";
          nativeBuildInputs = [toolchain];
          buildInputs = with pkgs; [];
          shellHook = ''
            ${checks.shellHook}
          '';
        };
      }
    );
}
