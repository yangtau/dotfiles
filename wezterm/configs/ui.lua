local wezterm = require "wezterm"
local M = {}

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
  local title = tab.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
  else
    title = " Tab #" .. tab.tab_index + 1 .. " "
  end

  return { { Text = title } }
end)

function M.append(config)
  -- theme
  local catppuccin = wezterm.color.get_builtin_schemes()["Catppuccin Latte"]
  catppuccin.background = "#ffffff"
  catppuccin.tab_bar.background = "#f0f0f0"
  catppuccin.tab_bar.inactive_tab.bg_color = catppuccin.tab_bar.background
  catppuccin.tab_bar.active_tab.bg_color = "#c2c2df"
  catppuccin.tab_bar.active_tab.fg_color = "#323222"

  local options = {
    default_cursor_style = "BlinkingBlock",
    font_size = 20,
    line_height = 1,
    -- Ll1 Oo0 \ | / 你好 😂 ⚠️
    font = wezterm.font_with_fallback {
      {
        family = "Monaco",
      },
      {
        family = "黑体-简",
      },
      {
        family = "Apple Color Emoji",
      },
    },
    color_schemes = {
      ["catppuccin"] = catppuccin,
    },
    color_scheme = "catppuccin",

    enable_scroll_bar = true,
    scrollback_lines = 100000,

    use_fancy_tab_bar = false,
    tab_bar_at_bottom = false,
    hide_tab_bar_if_only_one_tab = true,
    show_new_tab_button_in_tab_bar = false,
    text_background_opacity = 0.9,

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

  for key, value in pairs(options) do
    config[key] = value
  end
end

return M
