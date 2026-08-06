local wezterm = require "wezterm"

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
  local title = tab.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
  else
    title = " Tab #" .. tab.tab_index + 1 .. " "
  end

  return { { Text = title } }
end)

return {
  default_cursor_style = "BlinkingBlock",

  enable_scroll_bar = true,
  scrollback_lines = 100000,

  use_fancy_tab_bar = false,
  tab_bar_at_bottom = false,
  hide_tab_bar_if_only_one_tab = true,
  show_new_tab_button_in_tab_bar = true,
  -- text_background_opacity = 0.9,

  window_background_opacity = 1,

  inactive_pane_hsb = {
    saturation = 0.92,
    brightness = 0.92,
  },

  -- Tab bar can't have padding https://github.com/wez/wezterm/issues/3077
  window_padding = { left = 6, right = 6, top = 6, bottom = 1 },
  window_decorations = "RESIZE|MACOS_FORCE_ENABLE_SHADOW",
  -- macos_window_background_blur = 5,
}
