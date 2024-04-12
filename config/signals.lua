-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:activate({ context = "mouse_enter", raise = false })
end)

client.connect_signal("request::autoactivate", function(c)
  c:activate({ context = "autoactivate", raise = false })
end)

---Fix fullscreen clients not covering the entire screen due to the top bar (I think)
---@param c client
---@diagnostic disable-next-line: param-type-mismatch
client.connect_signal("property::fullscreen", function(c)
  if c.fullscreen then
    Capi.awful.placement.top(c, {
      honor_workarea = false,
      honor_padding = false,
    })
  end
end)

-- Center floating windows when they are moved to floating
---@diagnostic disable-next-line: param-type-mismatch
client.connect_signal("property::floating", function(c)
  Capi.awful.placement.centered(c, {
    honor_workarea = true,
  })
end)

-- focus the client under the mouse on startup
awesome.connect_signal("startup", function()
  Capi.gears.timer.delayed_call(function()
    local clients = Capi.awful.screen.focused():get_clients(true)
    local mouse_coords = mouse.coords()

    local function point_is_in_rect(point, rect)
      return point.x >= rect.x
        and point.x <= rect.x + rect.width
        and point.y >= rect.y
        and point.y <= rect.y + rect.height
    end

    local c
    for _, cl in ipairs(clients) do
      if point_is_in_rect(mouse_coords, cl:geometry()) then
        c = cl
        break
      end
    end
    if not c then
      return
    end
    c:activate({
      context = "startup",
      raise = true,
      action = true,
    })
  end)
end)
