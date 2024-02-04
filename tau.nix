{ config, lib, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # enable mDNS
  services.avahi = { 
    enable = true;
    nssmdns = true;
    publish = { enable = true; domain = true; addresses = true; };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
    settings.MaxAuthTries = 3;
    settings.MaxStartups = "5:30:10";
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    iputils
    usbutils
    wget
    lsof
    neovim
    tmux
  ];

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    shellAliases = {
      rm = "rm -i";
      mv = "mv -i";
      cp = "cp -i";
      rebuild = "sudo nixos-rebuild switch";
    };
    ohMyZsh = {
      enable = true;
      plugins = [ "tmux" "vi-mode" ];
      theme = "afowler";
      customPkgs = [ pkgs.nix-zsh-completions ];
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    withNodeJs = true;
    withRuby = true;
    withPython3 = true;
    configure = {
      customRC = ''
        " here your custom configuration goes!
        set tabstop=4
        set shiftwidth=4
        set softtabstop=4
        set expandtab
        set number
        set relativenumber
        set fileencodings=utf-8,gb18030,gbk,gb2312
        set spelllang=en,cjk
        set fillchars=stlnc:-
        set mouse=""
        set background=light
        set signcolumn=yes

        highlight SignColumn ctermbg=None
        highlight VertSplit  cterm=None

        let g:loaded_netrw = 1
        let g:loaded_netrwPlugin = 1
        let g:lightline = {
          \ 'active': {
          \   'left': [
          \     [ 'mode', 'paste' ], 
          \     [ 'readonly', 'filename', 'modified' ]
          \   ],
          \   'right':[
          \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ]
          \   ],
          \ },
          \ 'colorscheme': 'rosepine',
        \ }
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        # loaded on launch
        start = [
          sensible
          vim-tmux-navigator
          nvim-osc52
          vim-fugitive
          vim-peekaboo
          lightline-vim
        ];
        # manually loadable by calling `:packadd $plugin-name`
        opt = [ ];
      };
    };
  };

  programs.tmux = {
    enable = true;
    shortcut = "s"; # CTRL + s set-option -g prefix C-s
    keyMode = "vi";
    baseIndex = 1; # start window numbering at 1
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      mode-indicator
      sensible
    ];
    extraConfigBeforePlugins = ''
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
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.tau = {
    isNormalUser = true;
    linger = true;
    home = "/home/tau";
    hashedPassword = "$y$j9T$sZr2BQVoFnR8Pld1OgGs5.$rhMjy2zg1Qm42ytLh8x.DN5V09NLwIP5ts6xz7sWkeB";
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [
      clang-tools
      python3
      go
      gnumake
      git
      direnv
      jq
      htop
      gcc
    ];
  };

  fileSystems."/pan" = {
    device = "/dev/disk/by-label/pan";
    fsType = "ext4";
    options = [ "uid=tau" "gid=users" ];
  };
}
