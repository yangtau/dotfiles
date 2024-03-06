return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.sources = { "filesystem" }
      opts.source_selector = nil
      opts.window.position = "left"
      opts.window.mappings.o = false
      opts.window.mappings.C = "set_root"
      opts.filesystem.hijack_netrw_behavior = "open_default"
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
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astronvim.utils.status"
      local hl = require "astronvim.utils.status.hl"
      opts.statusline = {
        hl = { fg = "fg", bg = "bg" },
        status.component.mode { mode_text = { padding = { left = 1, right = 1 } } }, -- add the mode text
        -- status.component.git_branch {},
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

      opts.statuscolumn = nil
      return opts
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      defaults = {
        -- path_display = {
        --   truncate = 6,
        -- },
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.45 },
          vertical = { mirror = false },
          width = 0.9,
          height = 0.80,
          preview_cutoff = 100,
        },
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      highlights = {
        NormalFloat = { link = "Normal" },
      },
    },
  },
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
    "b0o/SchemaStore.nvim",
    enabled = false,
  },
  {
    "Shatur/neovim-session-manager",
    enabled = false,
  },
  {
    "stevearc/resession.nvim",
    enabled = false,
  },
  {
    "rcarriga/nvim-notify",
    enabled = false,
  },
}
