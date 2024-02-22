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
        "gopls",
        "gomodifytags",
        "iferr",
        "impl",
        "goimports",
        "staticcheck",
        -- "gofumpt",
        -- nix
        "nixpkgs-fmt",
        "nil",
        -- lua
        "lua-language-server",
        "stylua",
      })
    end,
  },
}
