vim.opt.termguicolors  = true
vim.opt.background     = 'light'
vim.opt.relativenumber = true
vim.opt.number         = true
vim.opt.signcolumn     = 'yes'
vim.opt.fileencodings  = 'utf-8,gb18030,gbk,gb2312'
vim.opt.mouse          = ''
vim.opt.tabstop        = 2
vim.opt.shiftwidth     = 2
vim.opt.expandtab      = true
vim.opt.breakindent    = true


vim.g.netrw_banner       = 0
vim.g.netrw_winsize      = 30
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader          = '\\'


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

local filetype_ignore_indent = {
  "help",
  "alpha",
  "dashboard",
  "Trouble",
  "trouble",
  "lazy",
  "mason",
  "notify",
  "toggleterm",
  "lazyterm",
  "NvimTree",
  "netrw",
  "tutor",
}

local plugins = {
  {
    "nmac427/guess-indent.nvim",
    config = function()
      require('guess-indent').setup {
        auto_cmd = true,                           -- Set to false to disable automatic execution
        override_editorconfig = false,             -- Set to true to override settings set by .editorconfig
        filetype_exclude = filetype_ignore_indent, -- A list of filetypes for which the auto command gets disabled
        buftype_exclude = {                        -- A list of buffer types for which the auto command gets disabled
          "help",
          "nofile",
          "terminal",
          "prompt",
        },
      }
    end
  },
  {
    "echasnovski/mini.indentscope",
    -- version = false, -- wait till new 0.7.0 release to put it back on semver
    -- event = "LazyFile",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetype_ignore_indent,
        callback = function() vim.b.miniindentscope_disable = true end,
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    -- event = "LazyFile",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = { filetypes = filetype_ignore_indent, },
    },
    main = "ibl",
  },
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
        name  = 'osc52',
        copy  = { ['+'] = copy, ['*'] = copy },
        paste = { ['+'] = paste, ['*'] = paste },
      }
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`

      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map("n", "<leader>ghu", gs.reset_hunk, "Undo Hunk")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
      end,
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
  },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
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
      vim.cmd.colorscheme 'catppuccin-latte'
    end,
    opts = {
      flavour = 'latte',              -- latte, frappe, macchiato, mocha
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
        keywords = { 'bold' },
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
          flamingo  = '#bb5d60',
          pink      = '#d54597',
          mauve     = '#a65fd5',
          red       = '#b7242f',
          maroon    = '#db3e68',
          peach     = '#e46f2a',
          yellow    = '#bc8705',
          green     = '#1a8e32',
          teal      = '#00a390',
          sky       = '#089ec0',
          sapphire  = '#0ea0a0',
          blue      = '#017bca',
          lavender  = '#855497',
          text      = '#444444',
          subtext1  = '#555555',
          subtext0  = '#666666',
          overlay2  = '#777777',
          overlay1  = '#888888',
          overlay0  = '#999999',
          surface2  = '#aaaaaa',
          surface1  = '#bbbbbb',
          surface0  = '#cccccc',
          base      = '#ffffff',
          mantle    = '#eeeeee',
          crust     = '#dddddd',
        },
      },
      custom_highlights = {},
      integrations = {
        cmp = true,
        nvimtree = false,
        treesitter = true,
        gitsigns = false,
        which_key = true,
        indent_blankline = {
          enabled = true,
          scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
          colored_indent_levels = false,
        },
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
    version = '*',
    build = ':TSUpdate',
    config = function()
      local opts = {
        ensure_installed = {
          'vim', 'vimdoc', 'lua', 'nix',
          'go', 'gosum', 'gomod',
          'c', 'query', 'rust', 'bash',
          'html', 'markdown',
          'yaml', 'json',
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
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        config = function() require("telescope").load_extension("fzf") end,
      },
    },
    config = function()
      require('telescope').setup {}
    end,
    keys = {

      --
      -- local telescope = require('telescope.builtin')
      -- vim.keymap.set('n', '<space>f', telescope.find_files, {})
      -- vim.keymap.set('n', '<space>g', telescope.live_grep, {})
      -- vim.keymap.set('n', '<space>b', telescope.buffers, {})
      -- vim.keymap.set('n', '<space>h', telescope.help_tags, {})
      -- vim.keymap.set('n', '<space>s',
      --   telescope.lsp_dynamic_workspace_symbols({
      --     symbols = require("lazyvim.config").get_kind_filter(),
      --   }), {})
      { "<space>f", "<cmd>Telescope find_files<cr>",                    desc = "Find Files" },
      { "<space>g", "<cmd>Telescope live_grep<cr>",                     desc = "Live Grep" },
      { "<space>b", "<cmd>Telescope buffers<cr>",                       desc = "Buffers" },
      { "<space>s", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Symbols" },
      { "<space>o", "<cmd>Telescope lsp_document_symbols<cr>",          desc = "Outlines" },
    },
  },
}


require('lazy').setup {
  spec = plugins,
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "catppuccin-latte", } },
  checker = { enabled = false }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        -- "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        -- "tarPlugin",
        -- "tohtml",
        -- "tutor",
        -- "zipPlugin",
      },
    },
  },
}

require('lsp')
require('keymap')
