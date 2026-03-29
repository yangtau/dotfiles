{
  description = "nix-darwin + home-manager config";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      llm-agents,
      ...
    }:
    let
      mkDarwinSystem =
        vars:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit vars; };
          modules = [
            home-manager.darwinModules.home-manager
            {
              nixpkgs.overlays = [
                llm-agents.overlays.default
              ];
            }
            ./darwin-configuration.nix
          ];
        };
    in
    {
      darwinConfigurations = {
        # 当前机器，新机器在此添加
        m3 = mkDarwinSystem {
          username = "bytedance";
          homeDirectory = "/Users/bytedance";
          hostname = "m3";
        };
        mini = mkDarwinSystem {
          username = "tau";
          homeDirectory = "/Users/tau";
          hostname = "mini";
        };
        air = mkDarwinSystem {
          username = "tau";
          homeDirectory = "/Users/tau";
          hostname = "air";
        };
      };
    };
}
