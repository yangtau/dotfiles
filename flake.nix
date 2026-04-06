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
    nixpkgs-nvim11.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      llm-agents,
      nixpkgs-nvim11,
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
                (
                  final: prev:
                  let
                    pkgs-nvim11 = import nixpkgs-nvim11 { system = "aarch64-darwin"; };
                  in
                  {
                    neovim = pkgs-nvim11.neovim;
                    neovim-unwrapped = pkgs-nvim11.neovim-unwrapped;
                  }
                )
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
