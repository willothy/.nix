local M = {}

local awful = Capi.awful
local beautiful = Capi.beautiful
local wibox = Capi.wibox
local ruled = Capi.ruled

client.connect_signal("request::titlebars", function(c)
  if
    ruled.client.matches(c, {
      rule_any = {
        name = {
          "Picture in picture",
          "Picture-in-Picture",
        },
      },
    })
  then
    local radius = 20

    local resize_handle = awful.popup({
      ontop = true,
      visible = false,
      placement = function(this)
        awful.placement.top(this, {
          parent = c,
          attach = true,
          margins = {
            top = -radius,
          },
        })
      end,
      widget = {
        widget = wibox.container.margin,
        layout = wibox.layout.fixed.horizontal,
        margins = {
          top = 4,
          bottom = 4,
          left = 4,
          right = 4,
        },
        forced_width = radius * 2,
        forced_height = radius * 2,
        {
          widget = wibox.container.place,
          halign = "center",
          valign = "center",
          fill_horizontal = true,
          {
            widget = wibox.widget.textbox,
            text = "",
            halign = "center",
            valign = "center",
          },
        },
      },
    })

    resize_handle:set_buttons({
      awful.button({}, 1, function()
        c:activate({
          context = "titlebar",
          action = "mouse_move",
        })
      end),
      awful.button({}, 3, function()
        c:activate({
          context = "titlebar",
          action = "mouse_resize",
        })
      end),
    })

    local timout = Capi.gears.timer({
      timeout = 1,
      autostart = false,
      call_now = false,
      single_shot = true,
      callback = function()
        if mouse.current_client == c then
          return
        end
        resize_handle.visible = false
      end,
    })

    resize_handle:connect_signal("mouse::enter", function()
      timout:stop()
      resize_handle.visible = true
    end)

    resize_handle:connect_signal("mouse::leave", function()
      timout:again()
    end)

    resize_handle:connect_signal("unmanage", function()
      resize_handle.visible = false
      timout:stop()
    end)

    c:connect_signal("request::unmanage", function()
      resize_handle.visible = false
      timout:stop()
    end)

    c:connect_signal("mouse::enter", function()
      resize_handle.visible = true
    end)

    c:connect_signal("mouse::leave", function()
      timout:again()
    end)

    return
  end

  local titlebar = awful.titlebar(c, {
    position = "top",
    size = 30,
    -- TODO: match color to top of window
    bg_focus = beautiful.dark_blue,
    bg_normal = beautiful.dark_blue,
  })

  local title_actions = {
    awful.button({}, 1, function()
      c:activate({
        context = "titlebar",
        action = "mouse_move",
      })
    end),
    awful.button({}, 3, function()
      c:activate({
        context = "titlebar",
        action = "mouse_resize",
      })
    end),
  }

  local buttons_loader = {
    layout = wibox.layout.fixed.horizontal,
    buttons = title_actions,
  }

  local function padded_button(button, margins)
    margins = margins or {
      left = 4,
      right = 4,
    }
    margins.top = 6
    margins.bottom = 6

    return wibox.widget({
      button,
      top = margins.top,
      bottom = margins.bottom,
      left = margins.left,
      right = margins.right,
      widget = wibox.container.margin,
    })
  end

  titlebar:setup({
    {
      {
        padded_button(awful.titlebar.widget.closebutton(c), {
          right = 4,
          left = 12,
        }),
        padded_button(awful.titlebar.widget.minimizebutton(c)),
        padded_button(awful.titlebar.widget.maximizedbutton(c)),
        layout = wibox.layout.fixed.horizontal,
      },
      widget = wibox.container.margin,
      margins = {
        top = 4,
      },
    },
    buttons_loader,
    buttons_loader,
    layout = wibox.layout.align.horizontal,
  })
end)

return M
