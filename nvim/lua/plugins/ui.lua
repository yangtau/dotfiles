local excluded_filetypes = {
  "Trouble",
  "aerial",
  "alpha",
  "checkhealth",
  "dashboard",
  "fzf",
  "help",
  "lazy",
  "lspinfo",
  "man",
  "mason",
  "neo-tree",
  "notify",
  "null-ls-info",
  "starter",
  "toggleterm",
  "undotree",
}
local excluded_buftypes = {
  "nofile",
  "prompt",
  "quickfix",
  "terminal",
}

return {
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "catppuccin-latte",
      status = {
        attributes = {
          mode = {
            bold = true,
          },
        },
      },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    ---@type CatppuccinOptions
    opts = {
      flavour = "latte", -- latte, frappe, macchiato, mocha
      integrations = {
        alpha = true,
        aerial = true,
        dap = true,
        dap_ui = true,
        mason = true,
        mini = true,
        neotree = false,
        notify = true,
        nvimtree = false,
        semantic_tokens = true,
        symbols_outline = true,
        telescope = true,
        ts_rainbow = false,
        which_key = true,
      },
      transparent_background = true,
      color_overrides = {
        latte = {
          rosewater = "#cc7983",
          flamingo = "#bb5d60",
          pink = "#d54597",
          mauve = "#a65fd5",
          red = "#b7242f",
          maroon = "#db3e68",
          peach = "#e46f2a",
          yellow = "#bc8705",
          green = "#1a8e32",
          teal = "#00a390",
          sky = "#089ec0",
          sapphire = "#0ea0a0",
          blue = "#017bca",
          lavender = "#855497",
          text = "#444444",
          subtext1 = "#555555",
          subtext0 = "#666666",
          overlay2 = "#777777",
          overlay1 = "#888888",
          overlay0 = "#999999",
          surface2 = "#aaaaaa",
          surface1 = "#bbbbbb",
          surface0 = "#cccccc",
          base = "#ffffff",
          mantle = "#eeeeee",
          crust = "#dddddd",
        },
      },
      custom_highlights = function(colors)
        return {
          StatusLine = { bg = "#eff1f5" },
          HeirlineNormal = { bg = colors.lavender },
          HeirlineInsert = { bg = colors.green },
          HeirlineVisual = { bg = colors.blue },
        }
      end,
    },
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"
      local hl = require "astroui.status.hl"
      opts.statusline = {
        hl = { fg = "fg", bg = "bg" },
        status.component.mode { mode_text = { padding = { left = 1, right = 1 } } }, -- add the mode text
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
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User AstroFile",
    opts = {
      indent = {
        char = "▏",
      },
      scope = {
        enabled = false,
      },
      whitespace = {
        remove_blankline_trail = true,
      },
    },
  },
  {
    "echasnovski/mini.indentscope",
    event = "User AstroFile",
    opts = { symbol = "▏", options = { try_as_border = true } },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Disable indentscope for certain filetypes",
        pattern = excluded_filetypes,
        callback = function(event) vim.b[event.buf].miniindentscope_disable = true end,
      })
      vim.api.nvim_create_autocmd("BufWinEnter", {
        desc = "Disable indentscope for certain buftypes",
        callback = function(event)
          if vim.tbl_contains(excluded_buftypes, vim.bo[event.buf].buftype) then
            vim.b[event.buf].miniindentscope_disable = true
          end
        end,
      })
      vim.api.nvim_create_autocmd("TermOpen", {
        desc = "Disable indentscope for terminals",
        callback = function(event) vim.b[event.buf].miniindentscope_disable = true end,
      })
    end,
  },
}
