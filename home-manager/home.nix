{ pkgs
, ...
}:

{
  imports = if builtins.pathExists ./home.local.nix then [ ./home.local.nix ] else [ ];
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    gnused
    delta
    nil

    gh

    orbstack

    rustup
    nodejs

    llm-agents.claude-code
    llm-agents.codex
    llm-agents.cursor-agent
    llm-agents.agent-browser
    # llm-agents.happy-coder
    llm-agents.amp
    llm-agents.droid
    llm-agents.openspec

    # install only telnet
    (runCommand "telnet" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.inetutils}/bin/telnet $out/bin/telnet
    '')

    # pin smux's tmux bridge as a standalone executable
    (runCommand "tmux-bridge" { } ''
      mkdir -p $out/bin
      cp ${
        fetchurl {
          url = "https://raw.githubusercontent.com/ShawnPana/smux/main/scripts/tmux-bridge";
          hash = "sha256-7WaGK/fTOmB9oUt8AEaUnYy7g7GlgpF6yk3GyTBYOV0=";
        }
      } $out/bin/tmux-bridge
      chmod +x $out/bin/tmux-bridge
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tau/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    EDITOR = "nvim";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      rm = "rm -i";
      mv = "mv -i";
      cp = "cp -i";
      vim = "nvim";
      v = "nvim";
      c = "claude";
      g = "git";
    };
    functions = {
      darwin-switch = ''
        sudo darwin-rebuild switch --flake path:$HOME/.config#(scutil --get LocalHostName) $argv
      '';

      # Vi mode indicator disabled — empty function suppresses the [N]/[I]/[V]/[R] bracket.
      fish_mode_prompt = "";
    };
    interactiveShellInit = ''
      fish_vi_key_bindings
    '';
  };

  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user.name = "yangtau";
      user.email = "yanggtau@gmail.com";
      diff.algorithm = "histogram";
      diff.tool = "nvimdiff";
      difftool.nvimdiff.cmd = "nvim -d $LOCAL $REMOTE";
      difftool.prompt = true;

      pull.rebase = true;
      push.default = "current";

      # merge.conflictstyle = "zdiff3";
      commit.verbose = true;

      rerere.enabled = true;
      help.autocorrect = 1;

      core.pager = "delta";
      delta.navigate = true;
      delta.light = true;

      url."git@github.com:".insteadOf = "https://github.com";
      url."git@gitlab.com:".insteadOf = "https://gitlab.com";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
