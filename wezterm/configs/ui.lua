local wezterm = require("wezterm")

local M = {}

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- default title.
local function tab_title(tab)
	local title = tab.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the default title.
	return "Tab #" .. tab.tab_index + 1
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
	-- local bg_color = "#eff1f5"
	-- local bg_active_color = "#e6e9ef"
	-- local fg_color = "#c8d3f5"
	-- local fg_active_color = "#82aaff"
	--
	-- -- Inactive tab
	-- local tab_bg_color = bg_active_color
	-- local tab_fg_color = fg_color
	--
	-- if tab.is_active then
	-- 	tab_bg_color = fg_active_color
	-- 	tab_fg_color = bg_color
	-- end

	return {
		-- { Background = { Color = tab_bg_color } },
		-- { Foreground = { Color = tab_fg_color } },
		{ Text = " " .. tab_title(tab) .. " " },
	}
end)

local custom_theme = wezterm.color.get_builtin_schemes()["Catppuccin Latte"]
custom_theme.background = "#ffffff"
custom_theme.tab_bar.active_tab.bg_color = "#82aaff"

function M.append(config)
	local options = {
		default_cursor_style = "SteadyBar", -- default: 'SteadyBlock'
		font_size = 18, -- default: 12.0
		font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "Noto Color Emoji" }),

		color_schemes = {
			["MyCat"] = custom_theme,
		},
		color_scheme = "MyCat",

		enable_scroll_bar = true, -- default: false
		scrollback_lines = 100000, --defauls: 3500

		-- Tab bar can't have padding https://github.com/wez/wezterm/issues/3077
		window_padding = { left = 6, right = 6, top = 6, bottom = 6 },

		use_fancy_tab_bar = false, -- default: true
		hide_tab_bar_if_only_one_tab = true, -- default: false
		tab_bar_at_bottom = false,
		show_new_tab_button_in_tab_bar = false,

		window_background_opacity = 1,
		window_decorations = "RESIZE",
	}

	for key, value in pairs(options) do
		config[key] = value
	end
end

return M
