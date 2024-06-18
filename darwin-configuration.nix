{ config, pkgs, ... }:

let
  # vars.nix defines some variables for this host
  username = (import ./vars.nix).username;
  homeDirectory = (import ./vars.nix).homeDirectory;
  hostname = (import ./vars.nix).hostname;
in
{
  imports = [
    <home-manager/nix-darwin>
    ./host.nix # config for this host only
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
  nix.gc.automatic = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # nix.settings.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # networking
  networking.hostName = "${hostname}";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    brews = [
    ];
    taps = [ ];
    casks = [
      # browser
      { name = "arc"; }
      # md editor
      { name = "typora"; }
      # terminal
      { name = "wezterm"; }
      # develop tools
      { name = "orbstack"; }
      # tools
      { name = "alt-tab"; }
      { name = "scroll-reverser"; }
      { name = "amethyst"; }
      { name = "hiddenbar"; }
      { name = "stretchly"; }
      # font
      { name = "font-fira-code-nerd-font"; }
      { name = "font-jetbrains-mono-nerd-font"; }
    ];
  };

  users.users.${username} = {
    name = username;
    home = homeDirectory;
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.${username} = { pkgs, ... }: {
    imports = [ ./home-manager/home.nix ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
