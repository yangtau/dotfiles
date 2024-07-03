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
        "markdown",
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
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        keyword = "bg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)(\(.+\))?:]], -- pattern or table of patterns, used for highlighting (vim regex)
      },
    },
    keys = {
      -- todo
      -- override default mappings
      { "<Leader>ft", "<Cmd>TodoTelescope<CR>", desc = "Find TODOs" },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next TODO comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous TODO comment",
      },
    },
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
    keys = {
      {
        "<C-]>",
        function()
          return vim.fn["codeium#Accept"]()
        end,
        "i",
        { expr = true },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        path_display = { "smart" },
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.4 },
          vertical = { mirror = false },
          width = 0.85,
          height = 0.80,
          preview_cutoff = 120,
        },
      },
    },
  },
}
