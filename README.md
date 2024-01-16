## Power Profiles to AMD & Intel P-STATE Energy Performance Preference

This fork is a stop-gap solution for those looking for proper AMD and Intel PSTATE driver power-saving and performance features to use automatically with Power Profiles Daemon.

This daemon closes this gap by monitoring Power Profiles current mode in the background and setting corresponding EPP profile for CPU. Whereas previous solutions were limited to AMD or required replacing PPD with TLP, this daemon intelligently detects which driver is active and adjusts accordingly with respect to the user's chosen enery profile in Power Profiles Daemon.

So far there are four modes of operation:

* PP set to 'power-saver' -> EPP set to 'power' (lowest energy usage preference)
* PP set to 'balanced':
    * if AC is disconnected -> EPP set to 'balance_power'
    * if AC is connected -> EPP set to 'balance_performance'
* PP set to 'performance' -> EPP set to 'performance'

There is no configuration required.

Tested on Fedora 39 Silverblue with 6.5.6 kernel on ASUS Zephyrus g14 2021 AMD Ryzen 9 5900HS, Asus Zephyrus 2023 AMD Ryzen 9 7840HS, and Lenovo Yoga 9i Gen 8 Intel Core i7 1360P.

dependencies:
* python3
* power-profiles-daemon (installed by default on Fedora 35+)

## NixOS Flake Setup

flake.nix:
```nix
{
  inputs.pp-to-epp.url = github:alychace/pp-to-epp;
  # needed so there's no power-profiles-daemon version mismatch
  inputs.pp-to-epp.inputs.nixpkgs.follows = "nixpkgs";
  outputs = {self, nixpkgs, ...}@inputs: {
    # yourhostname being your actual system's hostname
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
     
      specialArgs = { inherit inputs system; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
```
configuration.nix:
```nix
{
  imports = [
    inputs.pp-to-epp.nixosModules.pp-to-epp
  ];

  services.pp-to-epp.enable = true;
}
```


    
