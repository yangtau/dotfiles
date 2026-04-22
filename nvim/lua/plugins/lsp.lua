local function snacks_picker(method, opts)
  return function()
    require("snacks").picker[method](opts or {})
  end
end

return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      -- Configuration table of features provided by AstroLSP
      features = {
        codelens = true, -- enable/disable codelens refresh on start
        inlay_hints = true, -- enable/disable inlay hints on start
        semantic_tokens = true, -- enable/disable semantic token highlighting
        signature_help = true,
      },
      formatting = {
        format_on_save = {
          enabled = true, -- enable or disable format on save globally
          ignore_filetypes = {},
        },
        timeout_ms = 1000, -- default format timeout
      },
      servers = { "nil_ls", "rust_analyzer" },
      mappings = {
        n = {
          -- lsp
          ["<Leader>O"] = {
            function()
              require("aerial").toggle()
            end,
            desc = "Symbols outline",
          },
          ["<Leader>o"] = {
            snacks_picker "lsp_symbols",
            desc = "Search document symbols",
          },
          ["<Leader>s"] = {
            snacks_picker "lsp_workspace_symbols",
            desc = "Search workspace symbols",
          },
          ["gd"] = {
            snacks_picker "lsp_definitions",
            desc = "Search Definitions",
          },
          ["gri"] = {
            snacks_picker "lsp_implementations",
            desc = "Search Implementations",
          },
          ["gr"] = {
            snacks_picker("lsp_references", { include_declaration = false }),
            desc = "Search References",
          },
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      local astrocore = require "astrocore"
      opts.ensure_installed =
        astrocore.list_insert_unique(opts.ensure_installed, {
          "nil",
          "rust-analyzer",
        })
    end,
  },
}
