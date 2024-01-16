{
  description = "Power Profiles Daemon to P-STATE EPP";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: let
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];

    withPkgsFor = fn: nixpkgs.lib.genAttrs systems (system: fn system nixpkgs.legacyPackages.${system});
  in {
    nixosModules = rec {
      pp-to-epp = import ./nix/nixos-module.nix self;
      default = self.nixosModules.pp-to-epp;
    };

    packages = withPkgsFor (_: pkgs: rec  {
      pp-to-epp = pkgs.callPackage ./nix/package.nix {};
      default = pp-to-epp;
    });
  };
}
