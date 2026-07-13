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
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
    };
  };

  outputs =
    { nix-darwin
    , home-manager
    , llm-agents
    , ...
    }:
    let
      vars = import ./vars.nix;
    in
    {
      darwinConfigurations.${vars.hostname} =
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit vars; };
          modules = [
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit llm-agents;
              };
            }
            ./darwin-configuration.nix
          ];
        };
    };
}
