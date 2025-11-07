local wezterm = require "wezterm"

return {
  font_size = 17,
  -- line_height = 1,
  -- Ll1 Oo0 \ | / 你好 😂 ⚠️
  font = wezterm.font_with_fallback {
    {
      family = "Maple Mono NF CN",
    },
    {
      family = "Apple Color Emoji",
    },
  },
}
