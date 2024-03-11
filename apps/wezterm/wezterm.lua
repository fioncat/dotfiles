local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("SauceCodePro Nerd Font", { weight = "Medium" })
config.font_size = 14
config.command_palette_font_size = config.font_size * 1.1
config.freetype_load_target = "Light"

-- Remove the title bar
config.window_decorations = "RESIZE"

config.window_padding = { left = 0, right = 0, top = 10, bottom = 0 }

-- This require picom in i3wm
config.window_background_opacity = 0.97

-- https://github.com/nekowinston/wezterm-bar
require("plugin.bar").apply_to_config(config, {
	position = "top",
})

-- https://github.com/catppuccin/wezterm
require("plugin.catppuccin").apply_to_config(config, {
	sync = true,
	sync_flavors = { light = "mocha", dark = "mocha" },
})

require("config.keys").apply(config)

return config
