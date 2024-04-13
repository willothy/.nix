local wezterm = require("wezterm")
local sesh = require("sesh")

local process_icons = require("icons")
local palette = require("colors")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
	config:set_strict_mode(false)
end

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

config.window_frame = {
	font = wezterm.font({ family = "Fira Code", weight = "Bold" }),
	font_size = 12.0,
	border_left_width = "0.0cell",
	border_right_width = "0.0cell",
	border_bottom_height = "0.10cell",
	border_bottom_color = "#1a1b26",
	border_top_height = "0.0cell",
}

config.colors = {
	background = "#26283f",
}

config.inactive_pane_hsb = {
	saturation = 1.0,
	brightness = 1.0,
}

config.window_decorations = "RESIZE"

config.window_padding = {
	top = 5,
	bottom = "0.0cell",
	left = 10,
	right = 8,
}

config.launch_menu = {}

package.loaded.nvim = nil
package.loaded.keymap = nil
local nvim = require("nvim")
local keymap = require("keymap")

config.bypass_mouse_reporting_modifiers = "SHIFT"

config.keys = {}

nvim.apply_mappings(config.keys)
keymap.apply_mappings(config.keys)

-- pane_info.foreground_process_name isn't helpful on NixOS because of store paths.
-- calling get_foreground_process_info is supposedly slow, so cache the results by
-- in a map of foreground_process_name -> get_foregoround_process_info().name.
local pane_cache = {}

local function pane_cache_get(pane_info)
	local proc_name = pane_info.foreground_process_name
	if pane_cache[proc_name] then
		return pane_cache[proc_name]
	end

	local title = wezterm.mux.get_pane(pane_info.pane_id):get_foreground_process_info().name

	pane_cache[proc_name] = title

	return title
end

wezterm.on("format-tab-title", function(tab, tabs, _panes, _config, hover, _max_width)
	local has_unseen_output = false
	for _, pane in ipairs(tab.panes) do
		if pane.has_unseen_output then
			has_unseen_output = true
			break
		end
	end

	local title = {}
	table.insert(title, {
		Background = { Color = "#1a1b26" },
	})
	if tab.tab_index == 0 then
		table.insert(title, {
			Text = " ",
		})
	end
	if has_unseen_output then
		table.insert(title, {
			Foreground = { Color = palette.lemon_chiffon },
		})
	elseif tab.is_active then
		table.insert(title, {
			Foreground = { Color = palette.turquoise },
		})
	else
		table.insert(title, {
			Foreground = { Color = "#9196c2" },
		})
	end

	local proc_title = pane_cache_get(tab.active_pane) or "bruh"

	if process_icons[proc_title] ~= nil then
		table.insert(title, {
			Text = wezterm.format({
				process_icons[proc_title],
				{ Text = " " },
			}),
		})
	else
		table.insert(title, {
			Text = wezterm.format({
				{ Text = "󰧟" },
				{ Text = " " },
			}),
		})
	end
	table.insert(title, {
		Foreground = {
			Color = "#9196c2",
		},
	})

	if hover then
		table.insert(title, {
			Attribute = { Underline = "Single" },
		})
	end
	table.insert(title, {
		Text = proc_title,
	})
	table.insert(title, {
		Attribute = { Underline = "None" },
	})
	if tab.tab_index + 1 < #tabs then
		table.insert(title, {
			Text = " ",
		})
	end
	return title
end)

wezterm.on("update-right-status", function(window, pane)
	local name = pane:get_user_vars().sesh_name
	if name and name ~= "" then
		name = string.format("%s %s", name, "∘")
	else
		name = ""
	end

	local nvim_icon = ""
	if pane:get_user_vars().IS_NVIM == "true" then
		nvim_icon = ""
	end
	local time = wezterm.strftime("%l:%M %p ")
	if time:sub(1, 1) ~= " " then
		nvim_icon = nvim_icon .. " "
	end

	window:set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = "#9196c2" } },
		{ Text = nvim_icon },
		{ Text = name },
		{ Text = time },
	}))
end)

wezterm.on("augment-command-palette", function(_window, _pane)
	return {
		sesh.create,
		sesh.attach,
	}
end)

-- wezterm.on("new-tab-button-click", function(window, pane, button, _default_action)
-- 	if button == "Left" then
-- 		window:perform_action(sesh.create.action, pane)
-- 		return false
-- 	end
-- end)

config.hyperlink_rules = {
	-- Matches: a URL in parens: (URL)
	{
		regex = "\\((\\w+://\\S+)\\)",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in brackets: [URL]
	{
		regex = "\\[(\\w+://\\S+)\\]",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in curly braces: {URL}
	{
		regex = "\\{(\\w+://\\S+)\\}",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in angle brackets: <URL>
	{
		regex = "<(\\w+://\\S+)>",
		format = "$1",
		highlight = 1,
	},
	-- Then handle URLs not wrapped in brackets
	{
		regex = "\\b\\w+://\\S+[)/a-zA-Z0-9-]+",
		format = "$0",
	},
	-- implicit mailto link
	{
		regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
		format = "mailto:$0",
	},
	{ regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]], format = "mailto:$0" },
	-- file:// URI
	-- Compiled-in default. Used if you don't specify any hyperlink_rules.
	{ regex = [[\bfile://\S*\b]], format = "$0" },
}

-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
	regex = [[[^:]["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
	format = "https://www.github.com/$1/$3",
})

-- localhost, with protocol, with optional port and path
table.insert(config.hyperlink_rules, {
	regex = [[http(s)?://localhost(?>:\d+)?]],
	format = "http$1://localhost:$2",
})

-- localhost with no protocol, with optional port and path
table.insert(config.hyperlink_rules, {
	regex = [[[^/]localhost:(\d+)(\/\w+)*]],
	format = "http://localhost:$1",
})

config.warn_about_missing_glyphs = false

config.enable_kitty_keyboard = true
-- config.enable_csi_u_key_encoding = true

return config
