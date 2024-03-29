local wezterm = require("wezterm")
local M = {}

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
	local title = tab.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
	else
		title = "Tab #" .. tab.tab_index + 1
	end
	return {
		{ Text = " " .. title .. " " },
	}
end)

function M.append(config)
	-- theme
	local catppuccin = wezterm.color.get_builtin_schemes()["Catppuccin Latte"]
	catppuccin.background = "#ffffff"
	catppuccin.tab_bar.active_tab.bg_color = "#82aaff"

	local options = {
		default_cursor_style = "BlinkingBlock", -- default: 'SteadyBlock'
		font_size = 16,                       -- default: 12.0
		font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "Noto Color Emoji" }),

		color_schemes = {
			["catppuccin"] = catppuccin,
		},
		color_scheme = "catppuccin",

		enable_scroll_bar = true, -- default: false
		scrollback_lines = 100000, --defauls: 3500

		-- Tab bar can't have padding https://github.com/wez/wezterm/issues/3077
		window_padding = { left = 6, right = 6, top = 6, bottom = 6 },

		use_fancy_tab_bar = false,         -- default: true
		tab_bar_at_bottom = false,
		hide_tab_bar_if_only_one_tab = true, -- default: false
		show_new_tab_button_in_tab_bar = true,

		window_background_opacity = 0.95,
		macos_window_background_blur = 20,
		window_decorations = "RESIZE",
	}

	for key, value in pairs(options) do
		config[key] = value
	end
end

return M
