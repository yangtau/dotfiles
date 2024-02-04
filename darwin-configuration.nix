{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
  nix.gc.automatic = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    neovim
    tmux
    wget
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

  users.users.tau = {
    name = "tau";
    home = "/Users/tau";
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.tau = { pkgs, ... }: {
    imports = [ ./home-manager/home.nix ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
