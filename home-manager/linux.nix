{ pkgs
, vars
, ...
}:

{
  home.username = vars.username;
  home.homeDirectory = vars.homeDirectory;

  targets.genericLinux.enable = true;

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
