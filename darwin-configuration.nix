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
  ] ++ (
    # config for this host only
    if builtins.pathExists ./darwin-configuration.local.nix
    then [ ./darwin-configuration.local.nix ]
    else [ ]
  );

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/darwin-configuration.nix";

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
    };
    brews = [
    ];
    taps = [ ];
    casks = [
      # browser
      { name = "arc"; }
      # terminal
      { name = "wezterm"; }
      # tools
      { name = "alt-tab"; }
      { name = "scroll-reverser"; }
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
