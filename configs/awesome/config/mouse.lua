local awful = Capi.awful

awful.mouse.append_global_mousebindings({
  awful.button({}, 1, function()
    require("ui.menu").hide()
  end),
  awful.button({}, 3, function()
    require("ui.menu").show()
  end),
})

client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings({
    awful.button({}, 1, function(c)
      require("ui.menu").hide()
      c:activate({ context = "mouse_click" })
      -- c:activate({ context = "mouse_click", action = "mouse_resize" })
    end),
    awful.button({}, 3, function(_c)
      require("ui.menu").hide()
    end),
    awful.button({ Settings.modkey }, 1, function(c)
      require("ui.menu").hide()
      c:activate({ context = "mouse_click", action = "mouse_move" })
    end),
    awful.button({ Settings.modkey }, 3, function(c)
      require("ui.menu").hide()
      c:activate({ context = "mouse_click", action = "mouse_resize" })
    end),
  })
end)
