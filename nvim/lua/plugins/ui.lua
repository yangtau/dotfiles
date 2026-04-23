return {
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "claude",
    },
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"
      local hl = require "astroui.status.hl"
      opts.statusline = {
        hl = { fg = "fg", bg = "bg" },
        status.component.mode {
          mode_text = { padding = { left = 1, right = 1 } },
        }, -- add the mode text
        status.component.git_branch {},
        status.component.file_info {
          file_icon = {
            hl = hl.file_icon "statusline",
            padding = { left = 1, right = 1 },
          },
          file_modified = false,
        },
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.lsp {
          lsp_client_names = { icon = { padding = { right = 1 } } },
        },
        status.component.nav { scrollbar = false },
      }

      return opts
    end,
  },
}
