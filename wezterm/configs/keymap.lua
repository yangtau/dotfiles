local wezterm = require "wezterm"

local function is_vim_or_tmux(pane)
  local process = pane:get_foreground_process_name()
  local title = pane:get_title()
  -- wezterm.log_info("process: ", process)
  -- wezterm.log_info("title: ", title)
  return string.find(title, "NVIM")
      or string.find(title, "tmux")
      or string.find(process, "nvim")
      or string.find(process, "tmux")
      or string.find(process, "ssh")
end

local function split_nav(m)
  local direction = m.action[2]
  local op = m.action[1]
  m.action = wezterm.action_callback(function(win, pane)
    if is_vim_or_tmux(pane) then
      -- pass the keys through to vim/nvim
      win:perform_action({ SendKey = { key = m.key, mods = m.mods } }, pane)
    else
      if op == "resize" then
        win:perform_action({ AdjustPaneSize = { direction, 3 } }, pane)
      else
        win:perform_action({ ActivatePaneDirection = direction }, pane)
      end
    end
  end)
  return m
end

local function get_pane_info(pane, tab)
  if pane == nil then
    return nil
  end

  for _, item in ipairs(tab:panes_with_info()) do
    if item.pane:pane_id() == pane then
      return item
    end
  end
  return nil
end

local function open_or_focus_pane(
    tab_to_panes --[[ tab_id= {bottom=, last=} ]],
    arg
)
  return wezterm.action_callback(function(win, pane)
    local tab = win:active_tab()
    local panes = tab_to_panes[tab:tab_id()]

    local bottom_pane, last_pane
    if panes then
      bottom_pane = panes.bottom
      last_pane = panes.last
    end

    -- check if the bottom pane is still valid
    local bottom_pane_info = get_pane_info(bottom_pane, tab)
    local last_pane_info = get_pane_info(last_pane, tab)

    tab:set_zoomed(false)

    if not bottom_pane_info or not last_pane_info then -- no bottom pane, open one
      win:perform_action({ SplitPane = arg }, pane)
      tab_to_panes[tab:tab_id()] =
      { bottom = tab:active_pane():pane_id(), last = pane:pane_id() }
    elseif pane:pane_id() == bottom_pane then -- on bottom pane, switch to last
      last_pane_info.pane:activate()
    else                                      -- switch to bottom and set last
      bottom_pane_info.pane:activate()
      tab_to_panes[tab:tab_id()].last = pane:pane_id()
    end
  end)
end

local act = wezterm.action
-- pane opend by `
local tab_to_grave_pane = {} --[[ tab_id= {bottom=, last=} ]]
-- pane opend by /
local tab_to_left_pane = {}

return {
  disable_default_key_bindings = true,
  disable_default_mouse_bindings = true,
  unzoom_on_switch_pane = true,

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
    {
      event = { Down = { streak = 1, button = "Left" } },
      action = act.SelectTextAtMouseCursor "Cell",
    },
    {
      event = { Down = { streak = 2, button = "Left" } },
      action = act.SelectTextAtMouseCursor "Word",
    },
    {
      event = { Drag = { streak = 1, button = "Left" } },
      action = act.ExtendSelectionToMouseCursor "Cell",
    },

    -- scroll
    {
      event = { Down = { streak = 1, button = { WheelUp = 1 } } },
      action = act.ScrollByCurrentEventWheelDelta,
    },
    {
      event = { Down = { streak = 1, button = { WheelDown = 1 } } },
      action = act.ScrollByCurrentEventWheelDelta,
    },
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
    {
      mods = "SUPER",
      key = "t",
      action = act.SpawnCommandInNewTab {
        cwd = os.getenv "HOME",
        domain = "DefaultDomain",
      },
    },

    -- pane
    {
      mods = "SUPER",
      key = "w",
      action = act.CloseCurrentPane { confirm = true },
    },
    { mods = "SUPER", key = "z", action = act.TogglePaneZoomState },
    {
      mods = "CTRL",
      key = "-",
      action = act.SplitVertical { domain = "CurrentPaneDomain" },
    },
    {
      mods = "CTRL",
      key = "\\",
      action = act.SplitHorizontal { domain = "CurrentPaneDomain" },
    },
    split_nav { mods = "CTRL", key = "h", action = { "move", "Left" } },
    split_nav { mods = "CTRL", key = "j", action = { "move", "Down" } },
    split_nav { mods = "CTRL", key = "k", action = { "move", "Up" } },
    split_nav { mods = "CTRL", key = "l", action = { "move", "Right" } },
    split_nav {
      mods = "CTRL",
      key = "LeftArrow",
      action = { "resize", "Left" },
    },
    split_nav {
      mods = "CTRL",
      key = "DownArrow",
      action = { "resize", "Down" },
    },
    split_nav { mods = "CTRL", key = "UpArrow", action = { "resize", "Up" } },
    split_nav {
      mods = "CTRL",
      key = "RightArrow",
      action = { "resize", "Right" },
    },
    {
      mods = "CTRL",
      key = "`",
      action = open_or_focus_pane(
        tab_to_grave_pane,
        { direction = "Down", size = { Percent = 30 } }
      ),
    },
    {
      mods = "CTRL",
      key = "/",
      action = open_or_focus_pane(
        tab_to_left_pane,
        { direction = "Right", size = { Percent = 30 } }
      ),
    },
    {
      key = "!",
      mods = "CTRL|SHIFT",
      action = wezterm.action_callback(function(_, pane)
        pane:move_to_new_tab()
      end),
    },

    {
      key = "+",
      mods = "SUPER",
      action = act.IncreaseFontSize,
    },
    {
      key = "-",
      mods = "SUPER",
      action = act.DecreaseFontSize,
    },
  },
}
