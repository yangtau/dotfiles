{
  description = "nix-darwin + home-manager config";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

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
  };

  outputs =
    { nixpkgs
    , nix-darwin
    , home-manager
    , llm-agents
    , ...
    }:
    let
      vars = import ./vars.nix;
      lib = nixpkgs.lib;
      isDarwin = lib.hasSuffix "-darwin" vars.system;
      isLinux = lib.hasSuffix "-linux" vars.system;
    in
    assert lib.assertMsg (isDarwin || isLinux) "unsupported system: ${vars.system}";
    lib.optionalAttrs isDarwin {
      darwinConfigurations.${vars.hostname} = nix-darwin.lib.darwinSystem {
        system = vars.system;
        specialArgs = { inherit vars; };
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit llm-agents vars;
            };
          }
          ./darwin-configuration.nix
        ];
      };
    }
    // lib.optionalAttrs isLinux {
      homeConfigurations.${vars.username} = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = vars.system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit llm-agents vars;
        };
        modules = [
          ./home-manager/home.nix
          ./home-manager/linux.nix
        ];
      };
    };
}
