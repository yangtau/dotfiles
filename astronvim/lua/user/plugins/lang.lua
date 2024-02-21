local utils = require "astronvim.utils"
return {
  -- Golang support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, {
          "go", "gomod", "gosum", "gowork",
          "rust",
          "bash",
          "sql",
          "nix",
        })
      end
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
          utils.list_insert_unique(opts.ensure_installed, {
            "gomodifytags", "gofumpt", "iferr", "impl", "goimports", "staticcheck",
            "nixpkgs-fmt",
          })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, {
        "gopls",
        -- "nil",
      })
    end,
  },
}
