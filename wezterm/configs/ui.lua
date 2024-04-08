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
  catppuccin.tab_bar.active_tab.bg_color = "#c2c2df"
  catppuccin.tab_bar.active_tab.fg_color = "#111111"
  catppuccin.tab_bar.active_tab.intensity = "Bold"
  catppuccin.tab_bar.inactive_tab.fg_color = "#7c7f99"

  local options = {
    default_cursor_style = "BlinkingBlock",
    font_size = 16,
    font = wezterm.font_with_fallback { "Monaco", "Noto Sans Mono CJK SC", "Apple Color Emoji" },

    color_schemes = {
      ["catppuccin"] = catppuccin,
    },
    color_scheme = "catppuccin",

    enable_scroll_bar = true, -- default: false
    scrollback_lines = 100000, --defauls: 3500

    use_fancy_tab_bar = false, -- default: true
    tab_bar_at_bottom = false,
    hide_tab_bar_if_only_one_tab = true, -- default: false
    show_new_tab_button_in_tab_bar = false,
    text_background_opacity = 0.95, -- tab bar opacity

    window_background_opacity = 0.96,

    inactive_pane_hsb = {
      saturation = 0.92,
      brightness = 0.92,
    },

    -- Tab bar can't have padding https://github.com/wez/wezterm/issues/3077
    window_padding = { left = 6, right = 6, top = 6, bottom = 6 },
    window_decorations = "RESIZE|MACOS_FORCE_ENABLE_SHADOW",
    macos_window_background_blur = 10,
  }

  for key, value in pairs(options) do
    config[key] = value
  end
end

return M
