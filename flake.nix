{
  description = "GA NixOS configuration";

  inputs = {
	  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	  nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
	  nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
	  chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-auth.url = "github:numtide/nix-auth";

    #helix.url = "github:helix-editor/helix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/ba6fab29768007e9f2657014a6e134637100c57d";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-stable,
    sops-nix,
    chaotic,
    nixos-hardware,
    home-manager,
    ... }: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = {
      tuf = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
	      specialArgs = {
	        inherit inputs;
	        inherit system;
	        pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          sops-nix.nixosModules.sops
          nixos-hardware.nixosModules.asus-fx506hm
          chaotic.nixosModules.default
          ./configuration.nix
          ./modules/display
          ./modules/microsoft
          ./modules/virtualisation
          # make home-manager as a module of nixos
          # so that home-manager configuration will be
          # deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.ga = import ./modules/home;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
