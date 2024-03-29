local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local os = require("os")

-- local move_around = function(window, pane, direction_wez, direction_nvim)
-- 	local result = os.execute(
-- 		"env NVIM_LISTEN_ADDRESS=/tmp/nvim" .. pane:pane_id() .. " wezterm.nvim.navigator " .. direction_nvim
-- 	)
-- 	if result then
-- 		window:perform_action(wezterm.action({ SendString = "\x17" .. direction_nvim }), pane)
-- 	else
-- 		window:perform_action(wezterm.action({ ActivatePaneDirection = direction_wez }), pane)
-- 	end
-- end
--
-- wezterm.on("move-left", function(window, pane)
-- 	move_around(window, pane, "Left", "h")
-- end)
--
-- wezterm.on("move-right", function(window, pane)
-- 	move_around(window, pane, "Right", "l")
-- end)
--
-- wezterm.on("move-up", function(window, pane)
-- 	move_around(window, pane, "Up", "k")
-- end)
--
-- wezterm.on("move-down", function(window, pane)
-- 	move_around(window, pane, "Down", "j")
-- end)

function M.append(config)
	local options = {
		disable_default_key_bindings = true,
		disable_default_mouse_bindings = false,

		-- quick_select_alphabet = "colemak", -- default: qwerty

		-- Keyboard mappings
		-- timeout_milliseconds defaults to 1000
		leader = { key = "p", mods = "SUPER", timeout_milliseconds = 5000 },

		keys = {
			{ key = "p",  mods = "LEADER", action = act.ActivateCommandPalette },

			-- copy & paste
			{ key = "c",  mods = "SUPER",  action = act.CopyTo("Clipboard") },
			{ key = "v",  mods = "SUPER",  action = act.PasteFrom("Clipboard") },

			-- tabs
			{ key = "1",  mods = "SUPER",  action = act({ ActivateTab = 0 }) },
			{ key = "2",  mods = "SUPER",  action = act({ ActivateTab = 1 }) },
			{ key = "3",  mods = "SUPER",  action = act({ ActivateTab = 2 }) },
			{ key = "4",  mods = "SUPER",  action = act({ ActivateTab = 3 }) },
			{ key = "5",  mods = "SUPER",  action = act({ ActivateTab = 4 }) },
			{ key = "6",  mods = "SUPER",  action = act({ ActivateTab = 5 }) },
			{ key = "7",  mods = "SUPER",  action = act({ ActivateTab = 6 }) },
			{ key = "7",  mods = "SUPER",  action = act({ ActivateTab = 7 }) },
			{ key = "9",  mods = "SUPER",  action = act({ ActivateTab = -1 }) },
			{ key = "t",  mods = "SUPER",  action = act({ SpawnTab = "CurrentPaneDomain" }) },
			{ key = "w",  mods = "SUPER",  action = act({ CloseCurrentTab = { confirm = true } }) },

			-- pane
			{ key = "l",  mods = "SUPER",  action = act({ ActivatePaneDirection = "Right" }) },
			{ key = "h",  mods = "SUPER",  action = act({ ActivatePaneDirection = "Left" }) },
			{ key = "j",  mods = "SUPER",  action = act({ ActivatePaneDirection = "Down" }) },
			{ key = "k",  mods = "SUPER",  action = act({ ActivatePaneDirection = "Up" }) },
			{ key = "-",  mods = "SUPER",  action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
			{ key = "\\", mods = "SUPER",  action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
			{ key = "k",  mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
			{ key = "z",  mods = "LEADER", action = act.TogglePaneZoomState },
			{ key = "h",  mods = "CTRL",   action = wezterm.action({ EmitEvent = "move-left" }) },
			{ key = "l",  mods = "CTRL",   action = wezterm.action({ EmitEvent = "move-right" }) },
			{ key = "k",  mods = "CTRL",   action = wezterm.action({ EmitEvent = "move-up" }) },
			{ key = "j",  mods = "CTRL",   action = wezterm.action({ EmitEvent = "move-down" }) },
		},
	}

	for key, value in pairs(options) do
		config[key] = value
	end
end

return M
