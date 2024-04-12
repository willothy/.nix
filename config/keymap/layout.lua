local awful = Capi.awful

local function swap(dir)
  local c = client.focus
  awful.client.swap.global_bydirection(dir, client.focus)
  -- delay to account for animation
  Capi.gears.timer.delayed_call(function()
    c:jump_to(false)
  end)
end

local function focus(dir)
  awful.client.focus.global_bydirection(dir, client.focus)
end

awful.keyboard.append_global_keybindings({
  -- Swap windows
  -- Left
  awful.key({ Settings.modkey, "Shift" }, "Left", function()
    swap("left")
  end, { description = "Swap with the client to the left", group = "layout" }),
  awful.key({ Settings.modkey, "Shift" }, "h", function()
    swap("left")
  end, { description = "Swap with the client to the left", group = "layout" }),

  -- Right
  awful.key({ Settings.modkey, "Shift" }, "Right", function()
    swap("right")
  end, { description = "Swap with the client to the right", group = "layout" }),
  awful.key({ Settings.modkey, "Shift" }, "l", function()
    swap("right")
  end, { description = "Swap with the client to the right", group = "layout" }),

  -- Up
  awful.key({ Settings.modkey, "Shift" }, "Up", function()
    swap("up")
  end, { description = "Swap with the client above", group = "layout" }),
  awful.key({ Settings.modkey, "Shift" }, "k", function()
    swap("up")
  end, { description = "Swap with the client above", group = "layout" }),

  -- Down
  awful.key({ Settings.modkey, "Shift" }, "Down", function()
    swap("down")
  end, { description = "Swap with the client below", group = "layout" }),
  awful.key({ Settings.modkey, "Shift" }, "j", function()
    swap("down")
  end, { description = "Swap with the client below", group = "layout" }),

  -- Focus windows
  -- Up
  awful.key({ Settings.modkey }, "Up", function()
    focus("up")
  end, { description = "Focus the client above", group = "layout" }),
  awful.key({ Settings.modkey }, "k", function()
    focus("up")
  end, { description = "Focus the client above", group = "layout" }),

  -- Down
  awful.key({ Settings.modkey }, "Down", function()
    focus("down")
  end, { description = "Focus the client below", group = "layout" }),
  awful.key({ Settings.modkey }, "j", function()
    focus("down")
  end, { description = "Focus the client below", group = "layout" }),

  -- Left
  awful.key({ Settings.modkey }, "Left", function()
    focus("left")
  end, { description = "Focus the client to the left", group = "layout" }),
  awful.key({ Settings.modkey }, "h", function()
    focus("left")
  end, { description = "Focus the client to the left", group = "layout" }),

  -- Right
  awful.key({ Settings.modkey }, "Right", function()
    focus("right")
  end, { description = "Focus the client to the right", group = "layout" }),
  awful.key({ Settings.modkey }, "l", function()
    focus("right")
  end, { description = "Focus the client to the right", group = "layout" }),

  -- Focus screens
  awful.key({ Settings.modkey, "Control" }, "j", function()
    awful.screen.focus_relative(1)
    -- awful.focus.byidx(1)
  end, { description = "focus the next screen", group = "layout" }),
  awful.key({ Settings.modkey, "Control" }, "k", function()
    awful.screen.focus_relative(-1)
    -- awful.focus.byidx(-1)
  end, { description = "focus the previous screen", group = "layout" }),

  -- Layout
  awful.key({ Settings.modkey }, "Tab", function()
    awful.layout.inc(1)
  end, { description = "next layout", group = "layout" }),
  awful.key({ Settings.modkey, "Shift" }, "Tab", function()
    awful.layout.inc(-1)
  end, { description = "previous layout", group = "layout" }),
})

awful.keyboard.append_client_keybindings({
  awful.key({ Settings.modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
    if c.fullscreen then
      c:raise()
    end
  end, {
    description = "toggle fullscreen",
    group = "layout",
  }),
  awful.key({ Settings.modkey, "Shift" }, "f", function(c)
    c.floating = not c.floating
    if c.floating then
      c:raise()
    end
  end, {
    description = "toggle floating",
    group = "layout",
  }),
  Capi.awful.key({ Settings.modkey, "Shift" }, "c", function(c)
    c:kill()
  end, { description = "close window", group = "layout" }),
})
