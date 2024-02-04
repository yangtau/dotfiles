{ config, pkgs, ... }:

{

  nix.gc.automatic = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    neovim
    tmux
    wget
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  nixpkgs.config.allowUnfree = true;
  users.users.tau.packages = with pkgs; [
    gnused
    direnv
    git
    htop
    jq

    qemu

    go
    rustup
    nodejs_21
  ];

  homebrew = {
    enable = true;
    brews = [ ];
    casks = [
      { name = "alt-tab"; }
      { name = "amethyst"; }
      { name = "arc"; }
      { name = "iterm2"; }
      { name = "motrix"; }
    ];
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
