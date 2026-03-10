local wezterm = require "wezterm"

return {
  font_size = 16,
  -- line_height = 1,
  -- LliI1 Oo0 \ | / 你好 😂 ⚠️
  font = wezterm.font_with_fallback {
    {
      family = "JetBrains Mono",
    },
    {
      family = "Apple Color Emoji",
    },
  },
}
