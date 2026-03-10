{
  description = "nix-darwin + home-manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code-nix.url = "github:sadjow/claude-code-nix";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      claude-code-nix,
      codex-cli-nix,
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
                claude-code-nix.overlays.default
                codex-cli-nix.overlays.default
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
      };
    };
}
