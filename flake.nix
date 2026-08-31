{
  description = "nix-darwin + home-manager config";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
    grok-build = {
      url = "github:yangtau/grok-build";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gw = {
      url = "github:yangtau/gw";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-rust-prebuilt.follows = "grok-build/nix-rust-prebuilt";
    };
    shpell = {
      url = "github:yangtau/shpell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-rust-prebuilt.follows = "grok-build/nix-rust-prebuilt";
    };
  };

  outputs =
    { nixpkgs
    , nix-darwin
    , home-manager
    , llm-agents
    , grok-build
    , gw
    , shpell
    , ...
    }:
    let
      vars = import ./vars.nix;
      lib = nixpkgs.lib;
      isLinux = lib.hasSuffix "-linux" vars.system;
      homeSpecialArgs = { inherit llm-agents grok-build gw shpell vars; };
      commonHomeModules = [ ./home-manager/home.nix ];
    in
    # Only Linux uses standalone Home Manager; Darwin keeps nix-darwin integration.
    if isLinux then
      {
        homeConfigurations.${vars.username} = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = vars.system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = homeSpecialArgs;
          modules = commonHomeModules ++ [ ./home-manager/linux.nix ];
        };
      }
    else
      {
        darwinConfigurations.${vars.hostname} = nix-darwin.lib.darwinSystem {
          system = vars.system;
          specialArgs = { inherit vars; };
          modules = [
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = homeSpecialArgs;
                users.${vars.username}.imports = commonHomeModules ++ [ ./home-manager/darwin.nix ];
              };
            }
            ./darwin-configuration.nix
          ];
        };
      };
}
