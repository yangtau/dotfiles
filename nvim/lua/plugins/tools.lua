return {
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    config = function()
      require("kulala").setup {
        default_view = "body",
        formatters = {
          json = { "jq", "." },
          xml = { "xmllint", "--format", "-" },
          html = { "xmllint", "--format", "--html", "-" },
        },
        debug = false,
        icons = {
          inlay = {
            loading = " ",
            done = " ",
          },
          lualine = " ",
        },
        additional_curl_options = {},
      }

      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<CR>",
        ":lua require('kulala').run()<CR>",
        { noremap = true, silent = true }
      )

      local toggle_map = function()
        vim.api.nvim_buf_set_keymap(
          0,
          "n",
          "<C-CR>",
          ":lua require('kulala').toggle_view()<CR>",
          { noremap = true, silent = true }
        )
      end

      toggle_map()
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "kulala://ui",
        callback = toggle_map,
      })
    end,
  },
}
