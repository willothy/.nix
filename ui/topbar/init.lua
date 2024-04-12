local M = {}

local awful = Capi.awful
local beautiful = Capi.beautiful
local wibox = Capi.wibox
local gears = Capi.gears

screen.connect_signal("request::desktop_decoration", function(s)
  -- Each screen has its own tag table.
  awful.tag(
    { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    s,
    awful.layout.layouts[1]
  )

  local taglist = require("ui.topbar.taglist").new(s)
  local tasklist = require("ui.topbar.tasklist").new(s)
  local layoutbox = require("ui.topbar.layoutbox").new(s)

  local topbar = awful.wibar({
    position = "top",
    screen = s,
    width = s.geometry.width,
    height = beautiful.bar_height,
    shape = gears.shape.rectangle,
  })

  topbar:setup({
    {
      layout = wibox.layout.align.horizontal,
      {
        {
          -- s.index == screen.primary.index and powerbutton or nil,
          taglist,
          margins = {
            left = beautiful.useless_gap * 2,
          },
          widget = wibox.container.margin,
        },
        layout = wibox.layout.fixed.horizontal,
      },
      nil,
      {
        {
          {
            -- s.index == screen.primary.index and volumebutton or nil,
            s.index == screen.primary.index and require("ui.systray").new(s)
              or nil,
            s.index == screen.primary.index
                and awful.widget.textclock(
                  require("lib.string").colorize_markup(
                    "%I:%M %p",
                    beautiful.blue
                  )
                )
              or nil,
            layoutbox,
            spacing = 8,
            layout = wibox.layout.fixed.horizontal,
          },
          widget = wibox.container.margin,
          left = 8,
          right = 8,
          top = 6,
          bottom = 6,
        },
        layout = wibox.layout.fixed.horizontal,
      },
    },
    {
      {
        {
          tasklist,
          layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.margin,
        left = 8,
        right = 8,
        top = 6,
        bottom = 6,
      },
      halign = "center",
      widget = wibox.container.margin,
      layout = wibox.container.place,
      margins = {
        right = beautiful.useless_gap * 2,
      },
    },
    layout = wibox.layout.stack,
  })
end)

return M
