{
  description = "Lean Nix flake";

  inputs = {
    # System packages
    nixpkgs.follows = "lean4-nix/nixpkgs";

    # Lean 4 & Lake
    lean4-nix.url = "github:argumentcomputer/lean4-nix";

    # Helper: flake-parts for easier outputs
    flake-parts.url = "github:hercules-ci/flake-parts";

    fenix = {
      url = "github:nix-community/fenix";
      # Follow lean4-nix nixpkgs so we stay in sync
      inputs.nixpkgs.follows = "lean4-nix/nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      lean4-nix,
      fenix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Systems we want to build for
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem =
        {
          system,
          pkgs,
          ...
        }:
        let
          # Pins the Lean toolchain as a plain derivation.
          lean = lean4-nix.lib.${system}.fromToolchainFile ./lean-toolchain;
          lake2nix = pkgs.callPackage lean4-nix.lake { inherit lean; };

          # Pins the Rust toolchain
          rustToolchain = fenix.packages.${system}.fromToolchainFile {
            file = ./rust-toolchain.toml;
            sha256 = "sha256-P30Tm3O7vQAE725YtDCDHGjNrSsfZO4us11UwJGZSJo=";
          };
        in
        {
          packages.default = lake2nix.mkPackage {
            name = "template";
            src = lake2nix.cleanLakeSource ./.;
          };

          # Provide a unified dev shell with Lean + Rust
          devShells.default = pkgs.mkShell {
            packages = [
              lean
              rustToolchain
            ];
          };
        };
    };
}
