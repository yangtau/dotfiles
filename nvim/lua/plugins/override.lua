return {
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
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.sources = { "filesystem" }
      opts.source_selector = nil
      opts.window.position = "left"
      opts.window.mappings.o = false
      opts.window.mappings.C = "set_root"
      opts.window.mappings["/"] = "find_in_dir"
      -- opts.filesystem.hijack_netrw_behavior = "open_default"
      opts.filesystem.filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      }
      opts.popup_border_style = "rounded"
      opts.enable_git_status = false
      opts.enable_diagnostics = false
      return opts
    end,
  },
  -- {
  --   "rebelot/heirline.nvim",
  --   opts = function(_, opts)
  --     local status = require "astroui.status"
  --     local hl = require "astroui.status.hl"
  --     opts.statusline = {
  --       hl = { fg = "fg", bg = "bg" },
  --       status.component.mode { mode_text = { padding = { left = 1, right = 1 } } }, -- add the mode text
  --       -- status.component.git_branch {},
  --       status.component.file_info {
  --         file_icon = {
  --           hl = hl.file_icon "statusline",
  --           padding = { left = 1, right = 1 },
  --         },
  --         file_modified = false,
  --       },
  --       status.component.diagnostics(),
  --       status.component.fill(),
  --       status.component.cmd_info(),
  --       status.component.fill(),
  --       status.component.lsp {
  --         lsp_client_names = { icon = { padding = { right = 1 } } },
  --       },
  --       status.component.nav { scrollbar = false },
  --     }
  --
  --     opts.statuscolumn = nil
  --     return opts
  --   end,
  -- },
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "AstroNvim/astrotheme",
    enabled = false,
  },
  {
    "max397574/better-escape.nvim",
    enabled = false,
  },
  {
    "rcarriga/nvim-notify",
    enabled = false,
  },
}
