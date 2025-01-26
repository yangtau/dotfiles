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
          ignore_filetypes = { "json" },
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
            function()
              require("telescope.builtin").lsp_document_symbols {
                symbol_width = 60,
              }
            end,
            desc = "Search ducument symbols",
          },
          ["<Leader>s"] = {
            function()
              require("telescope.builtin").lsp_dynamic_workspace_symbols {
                fname_width = 50,
              }
            end,
            desc = "Search workspace symbols",
          },
          ["gd"] = {
            function()
              require("telescope.builtin").lsp_definitions {
                jump_type = "nerver",
                fname_width = 50,
              }
            end,
            desc = "Search Definitions",
          },
          ["gI"] = {
            function()
              require("telescope.builtin").lsp_implementations {
                jump_type = "nerver",
                fname_width = 50,
              }
            end,
            desc = "Search Implementations",
          },
          ["gr"] = {
            function()
              require("telescope.builtin").lsp_references {
                include_declaration = false,
                fname_width = 50,
              }
            end,
            desc = "Search References",
          },
        },
      },
    },
  },
}
