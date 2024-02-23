return {
  colorscheme = "catppuccin-latte",
  options = {
    opt = {
      mouse = "",
      clipboard = "",
      showtabline = 0,
      fixendofline = false,
      cmdheight = 1,
    },
  },
  g = {
    inlay_hints_enabled = true,
  },
  lsp = {
    formatting = {
      format_on_save = false, -- enable or disable automatic formatting on save
    },
  },
  diagnostics = {
    update_in_insert = false,
  },
  mappings = {
    n = {
      ["<leader>w"] = { "<cmd>Format<cr><cmd>w<cr>", desc = "Format and save" },
    },
  },

  heirline = {
    attributes = {
      mode = {
        bold = true,
      },
    },
  },
}
