vim.filetype.add {
  extension = {
    ["http"] = "http",
  },
}

-- Auto-reload files modified externally (e.g., by AI tools)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})
