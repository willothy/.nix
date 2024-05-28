local wezterm = require("wezterm")

local config = wezterm.config_builder()

config:set_strict_mode(false)

config.keys = {}

local cmd_palette = {}

local modules = {
	"hyperlinks",
	"status",
	"nvim",
	"sesh",
	"keymap",
}

for _, module in ipairs(modules) do
	package.loaded[module] = nil
	require(module)(config, wezterm, cmd_palette)
end

wezterm.on("augment-command-palette", function(_window, _pane)
	return cmd_palette
end)

config.front_end = "WebGpu"

config.animation_fps = 30
config.max_fps = 60

config.font = wezterm.font_with_fallback({
	"Maple Mono NF",
	-- "FiraCode Nerd Font",
})
config.font_size = 12.0
config.underline_thickness = 1
config.underline_position = -2.0

-- config.allow_square_glyphs_to_overflow_width = "Always"
config.allow_square_glyphs_to_overflow_width = "Never"

config.color_scheme = "tokyonight"

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 30

config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"

config.window_frame = {
	font = wezterm.font({ family = "Fira Code", weight = "Bold" }),
	font_size = 12.0,
	border_left_width = "0.0cell",
	border_right_width = "0.0cell",
	border_bottom_height = "0.10cell",
	border_bottom_color = "#1a1b26",
	border_top_height = "1.25cell",
}

config.colors = {
	background = "#26283f",
}

config.inactive_pane_hsb = {
	saturation = 1.0,
	brightness = 1.0,
}

config.window_padding = {
	top = 5,
	bottom = "0.0cell",
	left = 10,
	right = 8,
}

config.launch_menu = {}

config.bypass_mouse_reporting_modifiers = "SHIFT"

-- wezterm.on("new-tab-button-click", function(window, pane, button, _default_action)
-- 	if button == "Left" then
-- 		window:perform_action(sesh.create.action, pane)
-- 		return false
-- 	end
-- end)

config.warn_about_missing_glyphs = false

config.enable_kitty_keyboard = true
-- config.enable_csi_u_key_encoding = true

return config
