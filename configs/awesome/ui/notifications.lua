local naughty = Capi.naughty
local gears = Capi.gears
local beautiful = Capi.beautiful
local wibox = Capi.wibox

local dpi = beautiful.xresources.apply_dpi

Capi.ruled.notification.connect_signal("request::rules", function()
  -- All notifications will match this rule.
  Capi.ruled.notification.append_rule({
    rule = {},
    properties = {
      screen = Capi.awful.screen.preferred,
      implicit_timeout = 5,
    },
  })
end)

Capi.naughty.connect_signal("request::display", function(n)
  local app_name = {
    {
      {
        image = n.app_icon or beautiful.fallback_notif_icon,
        forced_height = 24,
        forced_width = 24,
        valign = "center",
        align = "center",
        clip_shape = gears.shape.circle,
        widget = wibox.widget.imagebox,
      },
      {
        markup = n.app_name or "",
        align = "left",
        valign = "center",
        widget = wibox.widget.textbox,
      },
      spacing = dpi(10),
      layout = wibox.layout.fixed.horizontal,
    },
    margins = dpi(10),
    widget = wibox.container.margin,
  }

  local separator = {
    {
      {
        markup = "",
        widget = wibox.widget.textbox,
      },
      top = 1,
      widget = wibox.container.margin,
    },
    bg = beautiful.light_black,
    widget = wibox.container.background,
  }

  local message = {
    {
      n.title == "" and nil or {
        markup = "<b>" .. n.title .. "</b>",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
      },
      {
        markup = n.title == "" and "<b>" .. n.message .. "</b>" or n.message,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
      },
      spacing = dpi(5),
      layout = wibox.layout.fixed.vertical,
    },
    top = dpi(15),
    left = dpi(12),
    right = dpi(12),
    bottom = dpi(5),
    widget = wibox.container.margin,
  }

  local actions = {
    {
      base_layout = wibox.widget({
        spacing = dpi(12),
        layout = wibox.layout.flex.vertical,
      }),
      widget_template = {
        {
          {
            {
              id = "text_role",
              widget = wibox.widget.textbox,
              markup = "",
            },
            widget = wibox.container.place,
          },
          top = dpi(7),
          bottom = dpi(7),
          left = dpi(4),
          right = dpi(4),
          widget = wibox.container.margin,
        },
        shape = gears.shape.rounded_bar,
        bg = beautiful.black,
        widget = wibox.container.background,
        create_callback = function(c)
          local timed = require("vendor.rubato").timed({
            duration = 0.2,
            intro = 0.0,
            easing = require("vendor.rubato").easing.linear,
            subscribed = function(pos)
              c:set_bg(
                require("lib.color").interpolate(
                  beautiful.black,
                  beautiful.light_black,
                  pos
                )
              )
            end,
            clamp_position = true,
          })

          c:connect_signal("mouse::enter", function()
            timed.target = 1
          end)
          c:connect_signal("mouse::leave", function()
            timed.target = 0
          end)
        end,
      },
      widget = naughty.list.actions,
      style = {
        underline_normal = false,
        underline_selected = false,
      },
    },
    margins = {
      top = dpi(12),
      bottom = dpi(12),
      left = dpi(12),
      right = dpi(12),
    },
    widget = wibox.container.margin,
  }

  naughty.layout.box({
    type = "notification",
    notification = n,
    screen = n.clients[1] and n.clients[1].screen or n.screen,
    position = "top_right",
    border_width = 0,
    border_color = beautiful.bg_normal .. "00",
    bg = beautiful.bg_normal .. "00",
    fg = beautiful.fg_normal,
    shape = function(cr, width, height)
      return gears.shape.partially_rounded_rect(
        cr,
        width,
        height,
        true,
        true,
        true,
        true,
        5
      )
    end,
    minimum_width = dpi(240),
    widget_template = {
      {
        {
          app_name,
          separator,
          layout = wibox.layout.fixed.vertical,
        },
        message,
        actions,
        spacing = dpi(7),
        layout = wibox.layout.align.vertical,
      },
      widget = wibox.container.background,
      bg = beautiful.bg_normal,
      shape = function(cr, width, height)
        return gears.shape.partially_rounded_rect(
          cr,
          width,
          height,
          true,
          true,
          true,
          true,
          5
        )
      end,
      fg = beautiful.fg_normal,
    },
  })
end)
