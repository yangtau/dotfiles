{ config, pkgs, ... }:

let
  # vars.nix defines some variables for this host
  username = (import ./vars.nix).username;
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
    brews = [ ];
    taps = [
      { name = "homebrew/cask-fonts"; }
    ];
    casks = [
      { name = "alt-tab"; }
      { name = "scroll-reverser"; }
      { name = "amethyst"; }
      { name = "arc"; }
      { name = "iterm2"; }
      { name = "motrix"; }
      { name = "font-fira-code-nerd-font"; }
      { name = "font-jetbrains-mono-nerd-font"; }
    ];
  };

  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.${username} = { pkgs, ... }: {
    imports = [ ./home-manager/home.nix ];
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "${username}";
    home.homeDirectory = "/Users/${username}";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
