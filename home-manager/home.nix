{ config, pkgs, ... }:

{
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
    htop
    jq

    # TODO: remove qemu and rust
    qemu
    rustup

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
      mode-indicator
      sensible
    ];
    extraConfig = ''
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

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    withNodeJs = true;
    withRuby = true;
    withPython3 = true;
    coc = {
      enable = true;
    };
    plugins = with pkgs.vimPlugins; [
      sensible
      vim-tmux-navigator
      nvim-osc52
      vim-fugitive
      vim-peekaboo
      lightline-vim
      nvim-treesitter
      nvim-osc52
      fzfWrapper
      nvim-tree-lua
      coc-go
      coc-sh
      coc-yank
      coc-git
      coc-pairs
      coc-fzf
    ];
    extraConfig = ''
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

      " coc config
      " coc-highlight
      autocmd CursorHold * silent call CocActionAsync('highlight')

      " show buffers
      " nnoremap <silent><nowait> <space>b  :<C-u>CocCommand fzf-preview.Buffers<CR>
      " " show project files
      " nnoremap <silent><nowait> <space>d  :<C-u>CocCommand fzf-preview.ProjectFiles<CR>
      " " show directory files
      " nnoremap <silent><nowait> <space>f  :<C-u>CocCommand fzf-preview.Lines<CR>

      nnoremap <silent> <space><space> :<C-u>CocFzfList<CR>
      nnoremap <silent> <space>a       :<C-u>CocFzfList diagnostics<CR>
      nnoremap <silent> <space>b       :<C-u>CocFzfList diagnostics --current-buf<CR>
      nnoremap <silent> <space>c       :<C-u>CocFzfList commands<CR>
      nnoremap <silent> <space>e       :<C-u>CocFzfList extensions<CR>
      nnoremap <silent> <space>l       :<C-u>CocFzfList location<CR>
      nnoremap <silent> <space>o       :<C-u>CocFzfList outline<CR>
      nnoremap <silent> <space>s       :<C-u>CocFzfList symbols<CR>
      nnoremap <silent> <space>p       :<C-u>CocFzfListResume<CR>

      set noshowmode

      function! LightlineGitBlame() abort
        let blame = get(b:, 'coc_git_blame', ''')
        return winwidth(0) > 120 ? blame : '''
      endfunction

      " coc-yank
      nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

      " TextEdit might fail if hidden is not set.
      set hidden

      " Some servers have issues with backup files, see #649.
      set nobackup
      set nowritebackup

      " Give more space for displaying messages.
      set cmdheight=2

      " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
      " delays and poor user experience.
      set updatetime=300

      " Don't pass messages to |ins-completion-menu|.
      set shortmess+=c

      " Use tab for trigger completion with characters ahead and navigate.
      " NOTE: There's always complete item selected by default, you may want to enable
      " no select by `"suggest.noselect": true` in your configuration file.
      " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
      " other plugin before putting this into your config.
      inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

      " Make <CR> to accept selected completion item or notify coc.nvim to format
      " <C-g>u breaks current undo, please make your own choice.
      inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

      function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " Use <c-space> to trigger completion.
      if has('nvim')
        inoremap <silent><expr> <c-space> coc#refresh()
      else
        inoremap <silent><expr> <c-@> coc#refresh()
      endif

      " Use `[g` and `]g` to navigate diagnostics
      " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
      nmap <silent> [g <Plug>(coc-diagnostic-prev)
      nmap <silent> ]g <Plug>(coc-diagnostic-next)

      " GoTo code navigation.
      nmap <silent> gv :call CocAction('jumpDefinition', 'vsplit')<CR>
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)

      " Use K to show documentation in preview window.
      nnoremap <silent> K :call ShowDocumentation()<CR>

      function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
          call CocActionAsync('doHover')
        else
          call feedkeys('K', 'in')
        endif
      endfunction

      " Highlight the symbol and its references when holding the cursor.
      autocmd CursorHold * silent call CocActionAsync('highlight')

      " Symbol renaming.
      nmap <leader>rn <Plug>(coc-rename)

      " Formatting selected code.
      "xmap <leader>f  <Plug>(coc-format-selected)
      "nmap <leader>f  <Plug>(coc-format-selected)
      xmap <leader>f  :call CocAction('format')<CR>
      nmap <leader>f  :call CocAction('format')<CR>

      augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder.
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
      augroup end

      " Applying codeAction to the selected region.
      " Example: `<leader>aap` for current paragraph
      xmap <leader>a  <Plug>(coc-codeaction-selected)
      nmap <leader>a  <Plug>(coc-codeaction-selected)

      " Remap keys for applying codeAction to the current buffer.
      nmap <leader>ac  <Plug>(coc-codeaction)
      " Apply AutoFix to problem on the current line.
      nmap <leader>qf  <Plug>(coc-fix-current)

      " Run the Code Lens action on the current line.
      nmap <leader>cl  <Plug>(coc-codelens-action)

      " Map function and class text objects
      " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
      xmap if <Plug>(coc-funcobj-i)
      omap if <Plug>(coc-funcobj-i)
      xmap af <Plug>(coc-funcobj-a)
      omap af <Plug>(coc-funcobj-a)
      xmap ic <Plug>(coc-classobj-i)
      omap ic <Plug>(coc-classobj-i)
      xmap ac <Plug>(coc-classobj-a)
      omap ac <Plug>(coc-classobj-a)

      " Remap <C-f> and <C-b> for scroll float windows/popups.
      if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      endif

      " Use CTRL-S for selections ranges.
      " Requires 'textDocument/selectionRange' support of language server.
      nmap <silent> <C-s> <Plug>(coc-range-select)
      xmap <silent> <C-s> <Plug>(coc-range-select)

      " Add `:Format` command to format current buffer.
      command! -nargs=0 Format :call CocActionAsync('format')

      " Add `:Fold` command to fold current buffer.
      command! -nargs=? Fold :call     CocAction('fold', <f-args>)

      " Add `:OR` command for organize imports of the current buffer.
      command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

      " Add (Neo)Vim's native statusline support.
      " NOTE: Please see `:h coc-status` for integrations with external plugins that
      " provide custom statusline: lightline.vim, vim-airline.
      " set statusline^=%{coc#status()}%{get(b:,'coc_current_function',''')}

      " Mappings for CoCList
      " Show all diagnostics.
      nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
      " Manage extensions.
      nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
      " Show commands.
      nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
      " Find symbol of current document.
      nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
      " Search workspace symbols.
      nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
      " Do default action for next item.
      nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
      " Do default action for previous item.
      nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
      " Resume latest coc list.
      nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
    '';
    extraLuaConfig = ''
      local function copy(lines, _)
        require('osc52').copy(table.concat(lines, '\n'))
      end

      local function paste()
        return {vim.fn.split(vim.fn.getreg(""), '\n'), vim.fn.getregtype("")}
      end

      vim.g.clipboard = {
        name = 'osc52',
        copy = {['+'] = copy, ['*'] = copy},
        paste = {['+'] = paste, ['*'] = paste},
      }

      -- Now the '+' register will copy to system clipboard using OSC52
      vim.keymap.set('n', '<leader>c', '"+y')
      vim.keymap.set('n', '<leader>cc', '"+yy')

      -- treesitter modules
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
          custom_captures = {
            -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
            -- ["foo.bar"] = "Identifier",
          },
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            scope_incremental = "grn",
            node_decremental = "grc",
            node_incremental = "grm",
          },
        },
      }

      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local function my_on_attach(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- use all default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- override default:
        vim.keymap.del('n', 's', { buffer = bufnr })
        vim.keymap.del('n', '<C-k>', { buffer = bufnr })
        vim.keymap.set('n', 'C', api.tree.change_root_to_node,          opts('CD'))
        vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
        vim.keymap.set('n', 's', api.node.open.vertical,                opts('Open: Vertical Split'))
        vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))

      end


      -- empty setup using defaults
      require("nvim-tree").setup {
        renderer = {
          indent_markers = { enable = true},
          icons = {
              show = {
                  file = false,
                  folder = false,
                  git = false,
                  folder_arrow = false,
                  modified = false,
              },
          },
        },

        on_attach = my_on_attach,
      }
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
      ls = "ls --color=auto";
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
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
