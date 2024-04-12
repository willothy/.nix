---@diagnostic disable: lowercase-global
pcall(require, "luarocks.loader")

Capi = {
  -- Standard awesome libraries
  awful = require("awful"),
  gears = require("gears"),

  -- Widget and layout library
  wibox = require("wibox"),

  -- Theme handling library
  beautiful = require("beautiful"),

  -- Notification library
  naughty = require("naughty"),

  -- Declarative object management
  ruled = require("ruled"),

  hotkeys_popup = require("awful.hotkeys_popup"),

  menubar = require("menubar"),
}

Programs = {
  terminal = "wezterm",
  explorer = "nautilus",
  browser = "brave",
  launcher = "rofi -show drun",
  editor = "nvim",
  visual_editor = "nvim -b",
  editor_cmd = "wezterm start -- nvim",
}

Settings = {
  modkey = "Mod4", -- super, the windows key or the command key
}

local M = {}

function M.setup_theme()
  Capi.beautiful.init(require("config.theme"))
end

-- Setup error message reporting, so that errors are shown in a
-- notification after the fallback config is loaded.
function M.setup_error_handling()
  -- Check if awesome encountered an error during startup and fell back to
  -- another config (This code will only ever execute for the fallback config)
  Capi.naughty.connect_signal(
    "request::display_error",
    function(message, startup)
      Capi.naughty.notification({
        urgency = "critical",
        title = "Oops, an error happened"
          .. (startup and " during startup!" or "!"),
        message = message,
      })
    end
  )
end

-- Start programs that should be started automatically with awesome
function M.autostart()
  -- network manager systray applet
  Capi.awful.spawn("nm-applet", false)

  -- authentication agent
  Capi.awful.spawn(
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
    false
  )

  -- volctl needs special treatment because it doesn't know
  -- how to ensure only one instance is running, and doesn't support
  -- the startup notification protocol.
  Capi.awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;'
      .. 'xrdb -merge <<< "awesome.started:true";'
      .. "volctl &"
      .. "dex --environment Awesome --autostart",
    false
  )
end

-- Execute xrandr script to setup screens
function M.setup_screens()
  -- local screens = Capi.gears.filesystem.get_configuration_dir() .. "screens.sh"
  -- Capi.awful.spawn(screens, false)
end

-- Start the compositor
function M.setup_compositor()
  Capi.awful.spawn("picom", false)
end

-- This is used to setup libraries and plugins that are used
-- throughout the configuration. It is called at the beginning of the
-- config so that these libraries can be assumed to be available
-- throughout the configuration.
function M.setup_dependencies()
  require("vendor.bling")
end

-- Pre-init steps
M.setup_error_handling()
M.setup_screens()
M.setup_compositor()

-- Basic initialization steps
M.setup_theme()

-- Setup for plugins, libraries, etc.
M.setup_dependencies()

-- Basic signals
require("config.signals")

-- Layout setup
require("config.layouts")

-- Rules
require("config.rules")

-- Mappings
require("config.mouse")
require("config.keymap")

-- UI Setup
require("ui.wallpaper")
require("ui.notifications")
require("ui.menu")
require("ui.window-switcher")

require("ui.titlebar")
require("ui.topbar")

-- Compositor and Environment setup
M.autostart()
