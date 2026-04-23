{
  pkgs,
  ...
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
    llm-agents.happy-coder
    llm-agents.amp
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

      # tmux (mirrors oh-my-zsh's tmux plugin; `ts` is upgraded to idempotent below)
      ta = "tmux attach -t";            # attach to session by name
      tad = "tmux attach -d -t";        # attach, detaching other clients
      tl = "tmux list-sessions";        # list sessions
      tksv = "tmux kill-server";        # kill server (all sessions)
      tkss = "tmux kill-session -t";    # kill a session by name
      td = "tmux detach";               # detach current session
    };
    functions = {
      darwin-switch = ''
        sudo darwin-rebuild switch --flake path:$HOME/.config#(scutil --get LocalHostName) $argv
      '';

      # ts [name]: attach to session if exists, else create it.
      # Smart variant of oh-my-zsh's `ts` (adds -A so re-running is idempotent).
      ts = ''
        set -l name $argv[1]
        if test -z "$name"
          set name default
        end
        tmux new-session -A -s $name
      '';

      # Vi mode indicator: colored [N]/[I]/[V]/[R] bracket.
      fish_mode_prompt = ''
        switch $fish_bind_mode
          case default
            set_color -o 3F7B79   # teal — normal
            printf '[N] '
          case insert
            set_color -o C96442   # coral — insert
            printf '[I] '
          case replace replace_one
            set_color -o B76D2B   # orange — replace
            printf '[R] '
          case visual
            set_color -o 765C92   # purple — visual
            printf '[V] '
        end
        set_color normal
      '';

      fish_prompt = ''
        set -l last_status $status

        # Hostname (no user). Dim on local; bold teal on SSH for clarity.
        if set -q SSH_CONNECTION
          set_color -o 3F7B79
        else
          set_color 8B8A82
        end
        printf '%s ' (prompt_hostname)

        # cwd in coral + bold.
        set_color -o C96442
        printf '%s' (prompt_pwd)

        # Git: branch/state colors come from __fish_git_prompt_color_*; parens dim.
        set_color 8B8A82
        fish_git_prompt ' (%s)'

        # Prompt char on the same line: coral, red on last-cmd failure.
        if test $last_status -ne 0
          set_color -o B54A4A
        else
          set_color -o C96442
        end
        printf ' ❯ '
        set_color normal
      '';

      fish_right_prompt = ''
        set -l last_status $status
        set -l parts

        # Command duration, only if >= 2s.
        if test -n "$CMD_DURATION" -a "$CMD_DURATION" -ge 2000
          set -l secs (math -s1 "$CMD_DURATION / 1000")
          set -a parts (set_color 8B8A82)" $secs""s"
        end

        # Exit code if non-zero.
        if test $last_status -ne 0
          set -a parts (set_color B54A4A)"✗ $last_status"
        end

        if test (count $parts) -gt 0
          printf '%s' $parts
          set_color normal
        end
      '';
    };
    interactiveShellInit = ''
      fish_vi_key_bindings
      set -g __fish_git_prompt_showdirtystate 1
      set -g __fish_git_prompt_showuntrackedfiles 1
      set -g __fish_git_prompt_showcolorhints 1
      set -g __fish_git_prompt_color_branch         3F7B79          # teal
      set -g __fish_git_prompt_color_dirtystate     C96442          # coral
      set -g __fish_git_prompt_color_stagedstate    6E8F48          # olive
      set -g __fish_git_prompt_color_untrackedfiles A67C00          # yellow
      set -g __fish_git_prompt_color_invalidstate   B54A4A          # red
      set -g __fish_git_prompt_color_cleanstate     3F7B79 --bold

      # ─── Claude theme: warm cream paper + coral accent ────────────
      # Syntax
      set -g fish_color_normal          1F1F1E
      set -g fish_color_command         3E6A92 --bold
      set -g fish_color_keyword         765C92
      set -g fish_color_quote           6E8F48
      set -g fish_color_redirection     C96442
      set -g fish_color_end             C96442
      set -g fish_color_error           B54A4A --bold
      set -g fish_color_param           2B2A27
      set -g fish_color_option          B76D2B
      set -g fish_color_comment         8B8A82 --italics
      set -g fish_color_operator        D97757
      set -g fish_color_escape          D97757
      set -g fish_color_autosuggestion  BAB8AD --italics
      set -g fish_color_cancel          B54A4A
      set -g fish_color_valid_path      --underline
      set -g fish_color_selection       --background=E4DFC9
      set -g fish_color_search_match    --background=F1DACA
      set -g fish_color_history_current C96442 --bold
      # Prompt
      set -g fish_color_cwd  C96442 --bold
      set -g fish_color_user 3F7B79
      set -g fish_color_host 3E6A92
      # Pager / completions
      set -g fish_pager_color_background           --background=EDE7D2
      set -g fish_pager_color_progress             C96442
      set -g fish_pager_color_prefix               C96442 --bold
      set -g fish_pager_color_completion           1F1F1E
      set -g fish_pager_color_description          8B8A82 --italics
      set -g fish_pager_color_selected_background  --background=E4DFC9
      set -g fish_pager_color_selected_prefix      C96442 --bold
      set -g fish_pager_color_selected_completion  1F1F1E --bold
      set -g fish_pager_color_selected_description 2B2A27

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
