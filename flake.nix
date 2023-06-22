{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, treefmt, system, lib, ... }:
        {
          packages.default = pkgs.writeShellApplication {
            name = "init";

            runtimeInputs = with pkgs; [ direnv git nix ];

            text = ''
              echo -n "project name: "
              read -r name

              mkdir "$name"
              cd "$name"
              git init
              nix flake init -t "github:cor/flake-templates#rust"
              touch .envrc
              echo "use flake" > .envrc
              direnv allow
            '';
          };
        };
    };
}
