return {
  colorscheme = "catppuccin-latte",
  plugins = {
    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require "astronvim.utils.status"
        opts.statusline = { -- statusline
          hl = { fg = "#feeeee", bg = "bg" },
          status.component.mode { mode_text = { padding = { left = 1, right = 1 } } }, -- add the mode text
          status.component.file_info { filetype = {}, filename = false, file_modified = false },
          status.component.diagnostics(),
          status.component.fill(),
          status.component.cmd_info(),
          status.component.fill(),
          status.component.lsp(),
          status.component.nav { scrollbar = false },
        }

        -- return the final configuration table
        return opts
      end,
    },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      lazy = false,
      -- init = function() vim.cmd.colorscheme "catppuccin-latte" end,
      opts = {
        flavour = "latte", -- latte, frappe, macchiato, mocha
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" }, -- Change the style of comments
          conditionals = { "italic" },
          keywords = { "bold" },
        },
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
        custom_highlights = function(C) return {} end,
        integrations = {
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
          cmp = true,
          neotree = false,
          treesitter = true,
          gitsigns = false,
          which_key = true,
          indent_blankline = {
            enabled = true,
            scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
            colored_indent_levels = false,
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
        },
      },
    },
  },
}
