local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local function is_vim_or_tmux(pane)
	local process = pane:get_foreground_process_name()
	local title = pane:get_title()
	-- wezterm.log_info("process: ", process)
	-- wezterm.log_info("title: ", title)
	return string.find(title, "NVIM")
		or string.find(title, "tmux")
		or string.find(process, "nvim")
		or string.find(process, "tmux")
end

local function split_nav(key, resize_or_move, direction)
	local mod = "CTRL"
	return {
		key = key,
		mods = mod,
		action = wezterm.action_callback(function(win, pane)
			if is_vim_or_tmux(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({ SendKey = { key = key, mods = mod } }, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction, 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction }, pane)
				end
			end
		end),
	}
end

function M.append(config)
	local options = {
		disable_default_key_bindings = true,
		disable_default_mouse_bindings = false,

		-- quick_select_alphabet = "colemak", -- default: qwerty

		-- Keyboard mappings
		-- timeout_milliseconds defaults to 1000
		-- leader = { key = "p", mods = "SUPER", timeout_milliseconds = 5000 },

		keys = {
			{ key = "p", mods = "SUPER", action = act.ActivateCommandPalette },

			-- copy & paste
			{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
			{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

			-- tabs
			{ key = "1", mods = "SUPER", action = act({ ActivateTab = 0 }) },
			{ key = "2", mods = "SUPER", action = act({ ActivateTab = 1 }) },
			{ key = "3", mods = "SUPER", action = act({ ActivateTab = 2 }) },
			{ key = "4", mods = "SUPER", action = act({ ActivateTab = 3 }) },
			{ key = "5", mods = "SUPER", action = act({ ActivateTab = 4 }) },
			{ key = "6", mods = "SUPER", action = act({ ActivateTab = 5 }) },
			{ key = "t", mods = "SUPER", action = act({ SpawnCommandInNewTab = { cwd = os.getenv("HOME") } }) },
			{ key = "w", mods = "SUPER", action = act({ CloseCurrentTab = { confirm = true } }) },

			-- pane
			{ key = "z", mods = "SUPER", action = act.TogglePaneZoomState },
			{ key = "-", mods = "CTRL", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
			{ key = "\\", mods = "CTRL", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
			split_nav("h", "move", "Left"),
			split_nav("j", "move", "Down"),
			split_nav("k", "move", "Up"),
			split_nav("l", "move", "Right"),
			split_nav("LeftArrow", "resize", "Left"),
			split_nav("DownArrow", "resize", "Down"),
			split_nav("UpArrow", "resize", "Up"),
			split_nav("RightArrow", "resize", "Right"),
		},
	}

	for key, value in pairs(options) do
		config[key] = value
	end
end

return M
