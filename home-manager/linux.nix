{ pkgs
, vars
, ...
}:

let
  configFlakeRef = ''path:$(realpath "$HOME/.config")'';
  configFlakeTarget = "${configFlakeRef}#${vars.username}";
in
{
  home.username = vars.username;
  home.homeDirectory = vars.homeDirectory;

  targets.genericLinux.enable = true;

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.profileExtra = ''
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  '';

  programs.zsh.shellAliases = {
    home-update = "nix flake update --flake \"${configFlakeRef}\" && $HOME/.config/home-manager/skills/update && home-manager switch --flake \"${configFlakeTarget}\"";
    home-switch = "home-manager switch --flake \"${configFlakeTarget}\"";
  };
}
