local awful = Capi.awful

awful.keyboard.append_global_keybindings({
  -- Launcher
  awful.key({ Settings.modkey }, "r", function()
    awful.spawn("rofi -show drun")
  end, { description = "rofi", group = "launcher" }),
  -- awful.key({}, "XF86LaunchB", function()
  --   awful.spawn("rofi -show window")
  -- end, { description = "Reveal", group = "launcher" }),

  -- Terminal
  awful.key({ Settings.modkey }, "Return", function()
    awful.spawn(Programs.terminal)
  end, { description = "open a terminal", group = "launcher" }),
  awful.key({ Settings.modkey }, "KP_Enter", function()
    require("ui.scratchpad").toggle()
  end, { description = "open a terminal", group = "launcher" }),
  awful.key({ Settings.modkey }, "w", function()
    -- TODO: Open window switcher
    awesome.emit_signal("bling::window_switcher::turn_on")
  end, { description = "Window Switcher", group = "bling" }),
})
