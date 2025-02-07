{
  description = "Microsoft Defender for Endpoint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    {
      nixosModules = rec {
        default = mdatp;
        mdatp = import ./nixos;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = rec {
          mdatp = pkgs.callPackage ./package.nix { };
          default = mdatp;
        };
      }
    );

}
