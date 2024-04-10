-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      -- notifications = false, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
      update_in_insert = false,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        mouse = "",
        clipboard = "",
        showtabline = 0,
        fixendofline = false,
        cmdheight = 1,
        background = "light",
        wrap = true,
        foldcolumn = "0",
        numberwidth = 1,
        signcolumn = "auto",
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      n = {
        ["<Leader>w"] = { "<cmd>Format<cr><cmd>w<cr>", desc = "Format and save buffer" },
        ["<Leader>W"] = { "<cmd>wqa<cr>", desc = "Save and quit all" },

        -- lsp
        ["<Leader>o"] = {
          function()
            require("telescope.builtin").lsp_document_symbols {
              symbol_width = 60,
              showline = false,
            }
          end,
          desc = "Search ducument symbols",
        },
        ["<Leader>O"] = {
          function() require("aerial").toggle() end,
          desc = "Symbols outline",
        },
        ["<Leader>s"] = {
          function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols {
              -- fname_width = 60,
            }
          end,
          desc = "Search workspace symbols",
        },

        -- todo
        -- override default mappings
        ["<Leader>ft"] = { "<Cmd>TodoTelescope<CR>", desc = "Find TODOs" },
        ["]t"] = { function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
        ["[t"] = { function() require("todo-comments").jump_prev() end, desc = "Previous TODO comment" },
      },
    },
  },
}
