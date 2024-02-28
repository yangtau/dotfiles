local maps = {
  n = {
    ["<leader>w"] = { "<cmd>Format<cr><cmd>w<cr>", desc = "Format and save buffer" },
    ["<leader>W"] = { "<cmd>wqa<cr>", desc = "Save and quit all" },
  },
  i = {},
  v = {},
  t = {},
}

local function opentermcmd(mode, direction)
  local pre = ""
  if mode == "i" then pre = "<Esc>" end

  local args = ""
  if direction == "float" then
    args = "direction=float"
  elseif direction == "horizontal" then
    args = "size=10 direction=horizontal"
  elseif direction == "vertical" then
    args = "size=80 direction=vertical"
  end
  return pre .. "<cmd>ToggleTerm " .. args .. "<cr>"
end

for _, mode in ipairs { "n", "i", "t" } do
  maps[mode]["<C-'>"] = { opentermcmd(mode, "float"), desc = "ToggleTerm float" }
  maps[mode]["<C-`>"] = { opentermcmd(mode, "horizontal"), desc = "ToggleTerm horizontal split" }
  maps[mode]["<C-/>"] = { opentermcmd(mode, "vertical"), desc = "ToggleTerm vertical split" }
end

return {
  colorscheme = "catppuccin-latte",
  options = {
    opt = {
      mouse = "",
      clipboard = "",
      showtabline = 0,
      fixendofline = false,
      cmdheight = 1,
      background = "light",
    },
  },
  g = {
    inlay_hints_enabled = true,
  },
  lsp = {
    formatting = {
      format_on_save = false, -- enable or disable automatic formatting on save
    },
  },
  diagnostics = {
    update_in_insert = false,
  },
  mappings = maps,
  heirline = {
    attributes = {
      mode = {
        bold = true,
      },
    },
  },
}
