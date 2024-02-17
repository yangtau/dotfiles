vim.opt.termguicolors = true
vim.opt.background = "light"
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.fileencodings="utf-8,gb18030,gbk,gb2312"
vim.opt.mouse=""
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.breakindent = true

vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = "\\"

vim.keymap.set('n', '<space>b', '<cmd>buffers<cr>:buffer<Space>')

vim.api.nvim_create_user_command('ReloadConfig', 'source $MYVIMRC', {})

---- lazy plugins --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },
  {
    "norcalli/nvim-colorizer.lua",
    lazy = true,
  },
  {
    "ojroques/nvim-osc52",
  },
  {
    "lewis6991/gitsigns.nvim",
  },
  {
    'neovim/nvim-lspconfig',
    -- "williamboman/mason.nvim",
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      -- "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = true,
  },
})
---- end ----


---- config catppuccin ----
require("catppuccin").setup({
    flavour = "latte", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = { "bold" },
        operators = {},
    },
    color_overrides = {
        latte = {
            rosewater = "#cc7983",
            flamingo = "#bb5d60",
            pink = "#d54597",
            mauve = "#a65fd5",
            red = "#b7242f",
            maroon = "#db3e68",
            peach = "#e46f2a",
            yellow = "#bc8705",
            green = "#1a8e32",
            teal = "#00a390",
            sky = "#089ec0",
            sapphire = "#0ea0a0",
            blue = "#017bca",
            lavender = "#855497",
            text = "#444444",
            subtext1 = "#555555",
            subtext0 = "#666666",
            overlay2 = "#777777",
            overlay1 = "#888888",
            overlay0 = "#999999",
            surface2 = "#aaaaaa",
            surface1 = "#bbbbbb",
            surface0 = "#cccccc",
            base = "#fffffd",
            mantle = "#eeeeee",
            crust = "#dddddd",
        },
    },
    custom_highlights = {},
    integrations = {
        cmp = true,
        nvimtree = false,
        treesitter = true,
        gitsigns = true,
        -- notify = false,
        -- mini = {
        --     enabled = true,
        --     indentscope_color = "",
        -- },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        native_lsp = {
          enabled = true,
          virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
          },
          underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
          },
          inlay_hints = {
              background = true,
          },
        },
   },
})
-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
---- end ----


---- nvim treesitter config ----
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "nix", "rust", "bash", "html" },
  sync_install = false,

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
  indent = { enable = true },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = "gnn",
      scope_incremental = "grn",
      node_decremental = "grc",
      node_incremental = "grm",
    },
  },
}
---- end ----


---- nvim tree config ---- 
require("nvim-tree").setup {
  renderer = {
    indent_markers = { enable = true},
    icons = {
        show = {
            -- file = false,
            -- folder = false,
            -- git = false,
            -- folder_arrow = false,
            -- modified = false,
        },
    },
  },
  on_attach = function (bufnr)
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
    vim.keymap.set('n', 'C', api.tree.change_root_to_node,  opts('CD'))
    vim.keymap.set('n', 's', api.node.open.vertical,        opts('Open: Vertical Split'))
    vim.keymap.set('n', 'a', api.fs.create,                 opts('Create'))
  end,
}
---- end ----


---- lsp config  ----
local lspconfig = require('lspconfig')

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Displays hover information about the symbol under the cursor
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    -- Jump to the definition
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    -- Jump to declaration
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    -- Jumps to the definition of the type symbol
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    -- Lists all the references 
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    -- Displays a function's signature information
    bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    -- Renames all references to the symbol under the cursor
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
    -- Selects a code action available at the current cursor position
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    -- Show diagnostics in a floating window
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    -- Move to the previous diagnostic
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    -- Move to the next diagnostic
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})


lspconfig.lua_ls.setup({
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        }
      })
    end
    return true
  end
})

lspconfig.nil_ls.setup {
  autostart = true,
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  },
}

---- end ----

---- osc copy over ssh ----
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
---- end ----

---- color ----
require('colorizer').setup { '*', }
---- end ----
