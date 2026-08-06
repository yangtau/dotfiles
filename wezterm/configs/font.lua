local wezterm = require "wezterm"

return {
  font_size = 18,
  -- line_height = 1,
  -- LliI1 Oo0 \ | / 你好，。 😂 ⚠️
  font = wezterm.font_with_fallback {
    -- Code and ASCII punctuation.
    "Monaco",
    -- Chinese text and Simplified Chinese punctuation.
    "PingFang SC",
    -- for Emoji
    "Apple Color Emoji",
  },
}
