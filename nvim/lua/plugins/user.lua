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
      opts.filesystem.window = opts.filesystem.window or {}
      opts.filesystem.window.mappings = opts.filesystem.window.mappings or {}
      opts.filesystem.window.mappings["/"] = "fuzzy_finder"
      opts.filesystem.filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      }
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
      {
        "<Leader>ft",
        function()
          local ok, snacks = pcall(require, "snacks")
          if ok and snacks.picker.todo_comments then
            snacks.picker.todo_comments()
          else
            vim.cmd.TodoQuickFix()
          end
        end,
        desc = "Find TODOs",
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      -- blink-cmp drives the UI, so disable copilot.lua's own ghost text / panel
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      sources = {
        -- `opts_extend` in AstroNvim appends this to the default sources list
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
