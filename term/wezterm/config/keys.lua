---@type wezterm
local wezterm = require("wezterm")
local act = wezterm.action

local shortcuts = {}

local map = function(key, mods, action)
	if type(mods) == "string" then
		table.insert(shortcuts, { key = key, mods = mods, action = action })
	elseif type(mods) == "table" then
		for _, mod in pairs(mods) do
			table.insert(shortcuts, { key = key, mods = mod, action = action })
		end
	end
end

local toggleTabBar = wezterm.action_callback(function(window)
	window:set_config_overrides({
		enable_tab_bar = not window:effective_config().enable_tab_bar,
	})
end)

local openUrl = act.QuickSelectArgs({
	label = "open url",
	patterns = { "https?://\\S+" },
	action = wezterm.action_callback(function(window, pane)
		local url = window:get_selection_text_for_pane(pane)
		wezterm.open_with(url)
	end),
})

local changeCtpFlavor = act.InputSelector({
	title = "Change Catppuccin flavor",
	choices = {
		{ label = "Mocha" },
		{ label = "Macchiato" },
		{ label = "Frappe" },
		{ label = "Latte" },
	},
	action = wezterm.action_callback(function(window, _, _, label)
		if label then
			window:set_config_overrides({ color_scheme = "Catppuccin " .. label })
		end
	end),
})

-- use 'Backslash' to split horizontally
map("/", "LEADER", act.SplitHorizontal({ domain = "CurrentPaneDomain" }))
-- and 'Minus' to split vertically
map("-", "LEADER", act.SplitVertical({ domain = "CurrentPaneDomain" }))
-- map 1-9 to switch to tab 1-9, Tab for the last tab
for i = 1, 9 do
	map(tostring(i), { "LEADER" }, act.ActivateTab(i - 1))
end
map("Tab", { "LEADER" }, act.ActivateLastTab)
-- 'hjkl' to move between panes
map("h", { "LEADER" }, act.ActivatePaneDirection("Left"))
map("j", { "LEADER" }, act.ActivatePaneDirection("Down"))
map("k", { "LEADER" }, act.ActivatePaneDirection("Up"))
map("l", { "LEADER" }, act.ActivatePaneDirection("Right"))
-- resize
map("h", "LEADER|SHIFT", act.AdjustPaneSize({ "Left", 5 }))
map("j", "LEADER|SHIFT", act.AdjustPaneSize({ "Down", 5 }))
map("k", "LEADER|SHIFT", act.AdjustPaneSize({ "Up", 5 }))
map("l", "LEADER|SHIFT", act.AdjustPaneSize({ "Right", 5 }))
-- spawn & close
map("c", "LEADER", act.SpawnTab("CurrentPaneDomain"))
map("x", "LEADER", act.CloseCurrentPane({ confirm = true }))
map("t", "LEADER", changeCtpFlavor)
map("t", { "SHIFT|CTRL" }, act.SpawnTab("CurrentPaneDomain"))
map("w", { "SHIFT|CTRL" }, act.CloseCurrentTab({ confirm = true }))
map("n", { "SHIFT|CTRL" }, act.SpawnWindow)
-- zoom states
map("z", { "LEADER" }, act.TogglePaneZoomState)
map("Z", { "LEADER" }, toggleTabBar)
-- copy & paste
map("Enter", "LEADER", act.ActivateCopyMode)
map("c", { "SHIFT|CTRL" }, act.CopyTo("Clipboard"))
map("v", { "SHIFT|CTRL" }, act.PasteFrom("Clipboard"))
map("f", { "SHIFT|CTRL" }, act.Search({ CaseInSensitiveString = "" }))
-- rotation
map("e", { "LEADER" }, act.RotatePanes("Clockwise"))
-- pickers
map(" ", "LEADER", act.QuickSelect)
map("o", { "LEADER" }, openUrl)
map("q", { "LEADER" }, act.PaneSelect({ alphabet = "123456789" }))
map("R", { "LEADER" }, act.ReloadConfiguration)
map("u", "SHIFT|CTRL", act.CharSelect)
map("p", { "SHIFT|CTRL" }, act.ActivateCommandPalette)
-- view
map("Enter", "ALT", act.ToggleFullScreen)
map("-", { "SUPER" }, act.DecreaseFontSize)
map("=", { "SUPER" }, act.IncreaseFontSize)
map("0", { "SUPER" }, act.ResetFontSize)
-- switch fonts
map("f", "LEADER", act.EmitEvent("switch-font"))
-- debug
map("l", "SHIFT|CTRL", act.ShowDebugOverlay)

map(
	"r",
	{ "LEADER" },
	act.ActivateKeyTable({
		name = "resize_mode",
		one_shot = false,
	})
)

-- Edit tab title manually
map(
	",",
	"LEADER",
	act.PromptInputLine({
		description = "Enter new name for tab",
		action = wezterm.action_callback(function(window, pane, line)
			-- line will be `nil` if they hit escape without entering anything
			-- An empty string if they just hit enter
			-- Or the actual line of text they wrote
			if line then
				window:active_tab():set_title(line)
			end
		end),
	})
)

-- Pin tab title to current working dirname
map(
	".",
	"LEADER",
	wezterm.action_callback(function(win, pane)
		-- See: https://wezfurlong.org/wezterm/config/lua/pane/get_current_working_dir.html
		local url = pane:get_current_working_dir()
		local name = string.gsub(url.file_path, "(.*[/\\])(.*)", "%2")
		win:active_tab():set_title(name)
	end)
)

-- Pin tab title to roxide display
map(
	";",
	"LEADER",
	wezterm.action_callback(function(win, pane)
		local url = pane:get_current_working_dir()

		local script = "roxide display " .. url.file_path
		local cmd = "zsh -c 'source ~/.zshrc; " .. script .. "'"

		local file = io.popen(cmd)
		if file == nil then
			return
		end
		local output = file:read("*a")
		file:close()

		output = string.gsub(output, "\n", "")
		if #output > 0 then
			win:active_tab():set_title(output)
		end
	end)
)

local key_tables = {
	resize_mode = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
	},
}

-- add a common escape sequence to all key tables
for k, _ in pairs(key_tables) do
	table.insert(key_tables[k], { key = "Escape", action = "PopKeyTable" })
	table.insert(key_tables[k], { key = "Enter", action = "PopKeyTable" })
	table.insert(key_tables[k], { key = "c", mods = "CTRL", action = "PopKeyTable" })
end

local M = {}
M.apply = function(c)
	c.leader = {
		key = "s",
		mods = "CTRL",
		timeout_milliseconds = math.maxinteger,
	}
	c.keys = shortcuts
	c.disable_default_key_bindings = true
	c.key_tables = key_tables
	c.mouse_bindings = {
		-- Change the default click behavior so that it only selects
		-- text and doesn't open hyperlinks
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = act.CompleteSelection("PrimarySelection"),
		},

		-- and make CTRL-Click open hyperlinks
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.OpenLinkAtMouseCursor,
		},

		-- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
		{
			event = { Down = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.Nop,
		},

		{
			event = { Down = { streak = 1, button = { WheelUp = 1 } } },
			mods = "NONE",
			action = wezterm.action.ScrollByLine(-5),
		},
		{
			event = { Down = { streak = 1, button = { WheelDown = 1 } } },
			mods = "NONE",
			action = wezterm.action.ScrollByLine(5),
		},
	}
end
return M
