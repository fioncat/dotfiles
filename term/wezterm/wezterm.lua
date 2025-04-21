local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
	{ family = "SauceCodePro Nerd Font", weight = "Medium" },
	"Noto Sans CJK SC", -- Require: noto-fonts-cjk
})
config.font_size = 14
config.command_palette_font_size = config.font_size * 1.1
config.freetype_load_target = "Light"

config.window_padding = { left = 0, right = 0, top = 10, bottom = 0 }

config.window_background_opacity = 0.97

config.native_macos_fullscreen_mode = true

-- This require: yay -S wezterm-git
-- TODO: Wait for https://github.com/wez/wezterm/pull/5264 to be released
config.enable_wayland = true

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
