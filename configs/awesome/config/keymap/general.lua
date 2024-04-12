local awful = require("awful")

awful.keyboard.append_global_keybindings({
  awful.key({ Settings.modkey }, "s", function()
    Capi.hotkeys_popup.show_help(client.focus)
  end, { description = "show help", group = "awesome" }),
  awful.key(
    { Settings.modkey, "Control" },
    "r",
    awesome.restart,
    { description = "reload awesome", group = "awesome" }
  ),
  -- awful.key(
  --   { Settings.modkey, "Shift" },
  --   "q",
  --   awesome.quit,
  --   { description = "quit awesome", group = "awesome" }
  -- ),
  awful.key({ Settings.modkey }, "v", function()
    local slider = require("ui.volume_slider")
    slider:show()
    awful.screen.focused().show_vol_osd = true
  end, { description = "volume", group = "awesome" }),
  awful.key({ Settings.modkey }, "x", function()
    require("ui.prompt").show()

    awful.prompt.run({
      prompt = "<b>Lua: </b>",
      font = "Fira Code NF 12",
      textbox = require("ui.prompt").widget,
      done_callback = function()
        require("ui.prompt").hide()
      end,
      exe_callback = function(input)
        require("ui.prompt").hide()
        if not input or #input == 0 then
          return
        end
        local result = awful.util.eval(input)
        if not result or #result == 0 then
          return
        end
        Capi.naughty.notify({ text = result })
      end,
      history_path = awful.util.get_cache_dir() .. "/history_eval",
    })
  end, { description = "lua execute prompt", group = "awesome" }),
})
