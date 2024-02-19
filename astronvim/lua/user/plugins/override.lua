return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.sources = { "filesystem" }
      opts.window = {
        position = "left",
        width = 30,
        mappings = {
          o = false,
          h = "parent_or_close",
          l = "child_or_open",
          C = "set_root",
        },
      }
      opts.filesystem = {
        hide_dotfiles = false,
        hide_gitignored = true,
        hijack_netrw_behavior = "open_default",
      }
      return opts
    end,
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astronvim.utils.status"
      opts.statusline = { -- statusline
        hl = { fg = "fg", bg = "bg" },
        status.component.mode { mode_text = { padding = { left = 1, right = 1 } } }, -- add the mode text
        status.component.file_info {},
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.lsp(),
        status.component.nav { scrollbar = false },
      }
      opts.winbar = nil
      -- opts.statuscolumn = nil
      return opts
    end,
  },
}
