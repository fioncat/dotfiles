local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
	{ family = "SauceCodePro Nerd Font", weight = "Medium" },
	"Noto Sans CJK SC", -- Require: noto-fonts-cjk
})
config.font_size = 14
config.command_palette_font_size = config.font_size * 1.1
config.freetype_load_target = "Light"

local is_linux = require("config.utils").is_linux()
if is_linux then
	-- In Linux, I use TWM, so we can treat the tab bar as window bar.
	config.window_decorations = "RESIZE" -- Hide original window bar
end

config.window_padding = { left = 0, right = 0, top = 10, bottom = 0 }

config.window_background_opacity = 0.97

-- TEMP, wait 5103 to be fixed
-- See: https://github.com/wez/wezterm/issues/5103
-- And: https://github.com/hyprwm/Hyprland/issues/4806
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
