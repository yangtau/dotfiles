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
        codelens = false,
        inlay_hints = true,
        semantic_tokens = true,
        signature_help = true,
        inline_completion = true,
        linked_editing_range = true,
      },
      formatting = {
        format_on_save = { enabled = true },
        timeout_ms = 1000,
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
          ["gi"] = {
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
}
