vim.opt.termguicolors = true
vim.opt.background = 'light'
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.fileencodings = 'utf-8,gb18030,gbk,gb2312'
vim.opt.mouse = ''
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.breakindent = true

vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = '\\'

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  {
    'norcalli/nvim-colorizer.lua',
    lazy = false,
    config = function()
      require('colorizer').setup { '*', }
    end
  },
  {
    'ojroques/nvim-osc52',
    lazy = false,
    config = function()
      local function copy(lines, _)
        require('osc52').copy(table.concat(lines, '\n'))
      end

      local function paste()
        return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
      end

      vim.g.clipboard = {
        name = 'osc52',
        copy = { ['+'] = copy, ['*'] = copy },
        paste = { ['+'] = paste, ['*'] = paste },
      }

      -- Now the '+' register will copy to system clipboard using OSC52
      -- TODO: why use these key mappings?
      vim.keymap.set('n', '<leader>c', '\'+y')
      vim.keymap.set('n', '<leader>cc', '\'+yy')
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    opts = {
      signs                        = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir                 = {
        follow_files = true
      },
      auto_attach                  = true,
      attach_to_untracked          = false,
      current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      -- TODO: put blame info in status line
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority                = 6,
      update_debounce              = 100,
      status_formatter             = nil,   -- Use default
      max_file_length              = 40000, -- Disable if file is longer than this (in lines)
      preview_config               = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    -- 'williamboman/mason.nvim',
  },
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
      'L3MON4D3/LuaSnip',
    },
    config = function()
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    opts = {
      renderer = {
        indent_markers = { enable = true },
      },
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- use all default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- override default:
        -- vim.keymap.del('n', 's', { buffer = bufnr })
        -- vim.keymap.del('n', '<C-k>', { buffer = bufnr })
        -- vim.keymap.set('n', '<C-t>', api.node.open.tab,         opts('Open: New Tab'))
        vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
        vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
        vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
      end,
    },
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    init = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
    opts = {
      flavour = 'latte', -- latte, frappe, macchiato, mocha
      background = {     -- :h background
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = false, -- disables setting the background color.
      show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
      term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false,              -- dims the background color of inactive window
      },
      no_italic = false,              -- Force no italic
      no_bold = false,                -- Force no bold
      no_underline = false,           -- Force no underline
      styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { 'italic' },      -- Change the style of comments
        conditionals = { 'italic' },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {
        latte = {
          rosewater = '#cc7983',
          flamingo = '#bb5d60',
          pink = '#d54597',
          mauve = '#a65fd5',
          red = '#b7242f',
          maroon = '#db3e68',
          peach = '#e46f2a',
          yellow = '#bc8705',
          green = '#1a8e32',
          teal = '#00a390',
          sky = '#089ec0',
          sapphire = '#0ea0a0',
          blue = '#017bca',
          lavender = '#855497',
          text = '#444444',
          subtext1 = '#555555',
          subtext0 = '#666666',
          overlay2 = '#777777',
          overlay1 = '#888888',
          overlay0 = '#999999',
          surface2 = '#aaaaaa',
          surface1 = '#bbbbbb',
          surface0 = '#cccccc',
          base = '#ffffff',
          mantle = '#eeeeee',
          crust = '#dddddd',
        },
      },
      custom_highlights = {},
      integrations = {
        cmp = true,
        nvimtree = false,
        treesitter = true,
        gitsigns = true,
        which_key = true,
        -- notify = false,
        -- mini = {
        --     enabled = true,
        --     indentscope_color = '',
        -- },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
          },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
          },
          inlay_hints = {
            background = true,
          },
        },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local opts = {
        ensure_installed = {
          'vim', 'vimdoc', 'lua', 'nix',
          'go', 'gosum', 'gomod',
          'c', 'query', 'rust', 'bash',
          'html', 'markdown',
        },
        sync_install = false,

        highlight = {
          enable = true,
          custom_captures = {
            -- Highlight the @foo.bar capture group with the 'Identifier' highlight group.
            -- ['foo.bar'] = 'Identifier',
          },
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = false,
          keymaps = {
            init_selection = 'gnn',
            scope_incremental = 'grn',
            node_decremental = 'grc',
            node_incremental = 'grm',
          },
        },
      }
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
})

require('lsp')
require('keymap')
