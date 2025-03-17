{ config, pkgs, ... }:

{
  imports =
    if builtins.pathExists ./home.local.nix
    then [ ./home.local.nix ]
    else [ ];
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
    git
    delta
    htop
    jq

    neovim
    ripgrep
    nil

    rustup
    nodejs_22

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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

  programs.tmux = {
    enable = true;
    shortcut = "s"; # CTRL + s set-option -g prefix C-s
    keyMode = "vi";
    baseIndex = 1; # start window numbering at 1
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      # mode-indicator
      sensible
    ];
    extraConfig = ''
      set -g allow-passthrough on
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      bind \\ split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # vi mode
      list-keys -T copy-mode-vi
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

      # status bar color
      set -g status-bg colour60
      set -g status-fg colour254
      set -g status-right '%Y-%m-%d %H:%M #{tmux_mode_indicator}'

      # mouse
      setw -g mouse on
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      rm = "rm -i";
      mv = "mv -i";
      cp = "cp -i";
      vim = "nvim";
      v = "nvim";
      ls = "ls --color=auto -G";
      q = "exit";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "tmux" "vi-mode" ];
      theme = "afowler";
    };
  };

  programs.git = {
    enable = true;
    userName = "yangtau";
    userEmail = "yanggtau@gmail.com";
    extraConfig = {
      diff.algorithm = "histogram";
      diff.tool = "nvimdiff";
      difftool.nvimdiff.cmd = "nvim -d $LOCAL $REMOTE";
      difftool.prompt = true;


      pull.rebase = true;
      push.default = "current";

      merge.conflictstyle = "zdiff3";
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
