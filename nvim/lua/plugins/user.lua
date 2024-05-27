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
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        height = 0.8,
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        keyword = "bg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)(\(.+\))?:]], -- pattern or table of patterns, used for highlighting (vim regex)
      },
    },
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
  {
    "max397574/better-escape.nvim",
    enabled = false,
  },
  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- configuration goes here
      ---@type string
      arg = "leetcode.nvim",

      ---@type lc.lang
      lang = "rust",

      cn = { -- leetcode.cn
        enabled = false, ---@type boolean
        translator = false, ---@type boolean
        translate_problems = false, ---@type boolean
      },

      ---@type lc.storage
      storage = {
        home = vim.env.HOME .. "/Workspaces/rustal/src",
        cache = vim.fn.stdpath "cache" .. "/leetcode",
      },
    },
  },
  {
    "Exafunction/codeium.vim",
    event = "User AstroFile",
    config = function()
      vim.keymap.set("i", "<C-]>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
    end,
  },
}
