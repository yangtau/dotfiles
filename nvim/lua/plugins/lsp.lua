return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      -- Configuration table of features provided by AstroLSP
      features = {
        autoformat = true, -- enable or disable auto formatting on start
        codelens = true, -- enable/disable codelens refresh on start
        inlay_hints = true, -- enable/disable inlay hints on start
        semantic_tokens = true, -- enable/disable semantic token highlighting
      },
      formatting = {
        format_on_save = {
          enabled = false, -- enable or disable format on save globally
        },
        timeout_ms = 1000, -- default format timeout
      },
      servers = { "nil_ls", "gopls", "rust_analyzer", "jqls" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local utils = require "astrocore"
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
        "markdown",
      })
    end,
  },
}
