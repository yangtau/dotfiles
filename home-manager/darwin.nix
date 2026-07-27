{ lib
, vars
, ...
}:

let
  configFlakeRef = ''path:$(realpath "$HOME/.config")'';
  configFlakeTarget = "${configFlakeRef}#${vars.hostname}";
in
{
  programs.zsh = {
    # Run after Home Manager's shell options (950), immediately before common init (1000).
    initContent = lib.mkOrder 990 ''
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        # Keep Homebrew completions in this shell, but do not export them to child zsh.
        typeset +x FPATH
      fi
    '';
    shellAliases = {
      darwin-update = "nix flake update --flake \"${configFlakeRef}\" && $HOME/.config/home-manager/skills/update && sudo darwin-rebuild switch --flake \"${configFlakeTarget}\"";
      darwin-switch = "sudo darwin-rebuild switch --flake \"${configFlakeTarget}\"";
    };
  };
}
