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
      opts.enable_diagnostics = true
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
    "max397574/better-escape.nvim",
    enabled = false,
  },
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "InsertEnter",
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    config = function()
      vim.keymap.set(
        "i",
        "<C-y>",
        'copilot#Accept("\\<CR>")',
        { expr = true, silent = true, replace_keycodes = false }
      )
    end,
  },
}
