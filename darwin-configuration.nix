{ pkgs
, vars
, ...
}:

let
  username = vars.username;
  homeDirectory = vars.homeDirectory;
  hostname = vars.hostname;
in
{
  # nix.package = pkgs.nix;
  nix.gc.automatic = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # networking
  networking.hostName = "${hostname}";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    htop
    wget
    tmux
    jq
    ripgrep
    neovim
  ];

  users.users.${username} = {
    name = username;
    home = homeDirectory;
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.${username} =
    { pkgs, ... }:
    {
      imports = [ ./home-manager/home.nix ];
    };

  system.primaryUser = "${username}";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
