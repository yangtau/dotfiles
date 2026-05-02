-- AstroCore: vim options, mappings, autocmds, filetypes, diagnostics.
-- See `:h astrocore` for the full opts shape.

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 200, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = true,
      highlighturl = true,
    },
    diagnostics = {
      severity_sort = true,
      virtual_text = true,
      underline = false,
      signs = false,
      update_in_insert = false,
    },
    options = {
      opt = {
        mouse = "",
        clipboard = "",
        showtabline = 0,
        fixendofline = false,
        cmdheight = 1,
        background = "light",
        wrap = true,
        foldcolumn = "0",
        numberwidth = 1,
      },
    },
    filetypes = {
      extension = { http = "http" },
    },
    autocmds = {
      auto_checktime = {
        {
          event = { "FocusGained", "BufEnter" },
          desc = "Reload files changed outside Neovim (e.g. by AI tools)",
          command = "checktime",
        },
      },
    },
    treesitter = {
      ensure_installed = {
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
      },
    },
    mappings = {
      n = {
        ["<Leader>w"] = { "<cmd>w<cr>", desc = "Save buffer" },
      },
    },
  },
}
