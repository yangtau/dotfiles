local utils = require "astronvim.utils"
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, {
        "go",
        "gomod",
        "gosum",
        "gowork",
        "rust",
        "bash",
        "sql",
        "nix",
        "json",
        "yaml",
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, {
        -- go
        -- "gopls",
        -- "gomodifytags",
        -- "iferr",
        -- "impl",
        -- "goimports",
        -- "staticcheck",
        -- "gofumpt",
        -- nix
        -- "nixpkgs-fmt",
        -- "nil",
        -- lua
        -- "lua-language-server",
        -- "stylua",
      })
    end,
  },
  {
    "Exafunction/codeium.vim",
    event = "User AstroFile",
    config = function()
      vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      -- vim.keymap.set("i", "<c-;>", function() return vim.fn["codeium#CycleCompletions"](0) end, { expr = true })
      -- vim.keymap.set("i", "<c-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      -- vim.keymap.set("i", "<c-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
    end,
  },
}
