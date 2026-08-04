{ pkgs
, lib
, vars
, ...
}:

let
  configFlakeRef = ''path:$(realpath "$HOME/.config")'';
  configFlakeTarget = "${configFlakeRef}#${vars.hostname}";

  terminal-browser =
    let
      version = "0.3.3";
    in
    pkgs.runCommand "terminal-browser-${version}"
      {
        src = pkgs.fetchurl {
          url = "https://terminal-browser.sh/install/dl/stable/v${version}/terminal-browser-darwin-arm64.tar.gz";
          hash = "sha256-gAQjGCeiscquAyL5mEgllp1xbtVTwtfM3HhNPPhH/Qk=";
        };
        meta = {
          description = "Chromium-rendered browser that runs inside a kitty-graphics-capable terminal";
          homepage = "https://github.com/zenbu-labs/terminal-browser";
          platforms = [ "aarch64-darwin" ];
        };
      } ''
      mkdir -p $out
      tar -xzf $src -C $out --strip-components=1
      cat > $out/bin/terminal-browser <<EOF
      #!/bin/sh
      export TERMINAL_BROWSER_DIST_ROOT="$out"
      export ELECTRON_RUN_AS_NODE=1
      exec "$out/electron/terminal-browser.app/Contents/MacOS/terminal-browser" "$out/cli/dist/main.js" "\$@"
      EOF
      chmod +x $out/bin/terminal-browser
    '';
in
{
  home.packages = [ terminal-browser ];

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
