local wezterm = require "wezterm"

local M = {}

local function is_vim_or_tmux(pane)
  local process = pane:get_foreground_process_name()
  local title = pane:get_title()
  -- wezterm.log_info("process: ", process)
  -- wezterm.log_info("title: ", title)
  return string.find(title, "NVIM")
    or string.find(title, "tmux")
    or string.find(process, "nvim")
    or string.find(process, "tmux")
end

function M.append(config)
  local act = wezterm.action

  local options = {
    disable_default_key_bindings = true,
    disable_default_mouse_bindings = true,

    -- quick_select_alphabet = "colemak", -- default: qwerty

    -- Keyboard mappings
    -- timeout_milliseconds defaults to 1000
    -- leader = { key = "p", mods = "SUPER", timeout_milliseconds = 5000 },

    mouse_bindings = {
      -- open link
      {
        event = { Up = { streak = 1, button = "Left" } },
        action = act.OpenLinkAtMouseCursor,
        mods = "SUPER",
      },

      -- copy text selected
      {
        event = { Up = { streak = 2, button = "Left" } },
        action = act.CompleteSelection "ClipboardAndPrimarySelection",
      },
      {
        event = { Up = { streak = 1, button = "Left" } },
        action = act.CompleteSelection "ClipboardAndPrimarySelection",
      },

      -- select text
      { event = { Down = { streak = 1, button = "Left" } }, action = act.SelectTextAtMouseCursor "Cell" },
      { event = { Down = { streak = 2, button = "Left" } }, action = act.SelectTextAtMouseCursor "Word" },
      { event = { Drag = { streak = 1, button = "Left" } }, action = act.ExtendSelectionToMouseCursor "Cell" },

      -- resize font
      {
        event = { Down = { streak = 1, button = { WheelUp = 1 } } },
        mods = "SUPER",
        action = act.IncreaseFontSize,
      },
      {
        event = { Down = { streak = 1, button = { WheelDown = 1 } } },
        mods = "SUPER",
        action = act.DecreaseFontSize,
      },

      -- scroll
      { event = { Down = { streak = 1, button = { WheelUp = 1 } } }, action = act.ScrollByCurrentEventWheelDelta },
      { event = { Down = { streak = 1, button = { WheelDown = 1 } } }, action = act.ScrollByCurrentEventWheelDelta },
    },

    keys = {
      { mods = "SUPER", key = "p", action = act.ActivateCommandPalette },

      -- copy & paste
      { mods = "SUPER", key = "c", action = act.CopyTo "Clipboard" },
      { mods = "SUPER", key = "v", action = act.PasteFrom "Clipboard" },

      -- tabs
      { mods = "SUPER", key = "1", action = act.ActivateTab(0) },
      { mods = "SUPER", key = "2", action = act.ActivateTab(1) },
      { mods = "SUPER", key = "3", action = act.ActivateTab(2) },
      { mods = "SUPER", key = "4", action = act.ActivateTab(3) },
      { mods = "SUPER", key = "5", action = act.ActivateTab(4) },
      { mods = "SUPER", key = "6", action = act.ActivateTab(5) },
      { mods = "SUPER", key = "7", action = act.ActivateTab(6) },
      { mods = "SUPER", key = "8", action = act.ActivateTab(7) },
      { mods = "SUPER", key = "9", action = act.ActivateTab(8) },
      { mods = "SUPER", key = "0", action = act.ActivateTab(9) },
      { mods = "SUPER", key = "t", action = act.SpawnCommandInNewTab { cwd = os.getenv "HOME" } },

      -- pane
      { mods = "SUPER", key = "w", action = act.CloseCurrentPane { confirm = true } },
      { mods = "SUPER", key = "z", action = act.TogglePaneZoomState },
      { mods = "SUPER", key = "-", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
      { mods = "SUPER", key = "\\", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
      { mods = "SUPER", key = "h", action = act.ActivatePaneDirection "Left" },
      { mods = "SUPER", key = "j", action = act.ActivatePaneDirection "Down" },
      { mods = "SUPER", key = "k", action = act.ActivatePaneDirection "Up" },
      { mods = "SUPER", key = "l", action = act.ActivatePaneDirection "Right" },
      { mods = "SUPER", key = "LeftArrow", action = act.AdjustPaneSize { "Left", 3 } },
      { mods = "SUPER", key = "DownArrow", action = act.AdjustPaneSize { "Down", 3 } },
      { mods = "SUPER", key = "UpArrow", action = act.AdjustPaneSize { "Up", 3 } },
      { mods = "SUPER", key = "RightArrow", action = act.AdjustPaneSize { "Right", 3 } },
      { mods = "SUPER", key = "`", action = act.SplitPane { direction = "Down", size = { Percent = 30 } } },
      { mods = "SUPER", key = "/", action = act.SplitPane { direction = "Right", size = { Percent = 30 } } },
    },
  }

  for key, value in pairs(options) do
    config[key] = value
  end
end

return M
