local awful = Capi.awful
local beautiful = Capi.beautiful
local wibox = Capi.wibox
local gears = Capi.gears

local ret = {}

ret.widget = wibox.widget.textbox()

ret.popup = awful.popup({
  visible = false,
  shape = function(cr, w, h)
    return gears.shape.rounded_rect(cr, w, h, 5)
  end,
  bg = beautiful.bg_normal .. "00",
  fg = beautiful.fg_normal,
  ontop = true,
  placement = awful.placement.centered,
  screen = awful.screen.focused(),
  widget = wibox.widget({
    {
      {
        ret.widget,
        widget = wibox.container.margin,
        margins = 12,
      },
      shape = function(cr, w, h)
        return gears.shape.rounded_rect(cr, w, h, 5)
      end,
      bg = beautiful.bg_normal,
      widget = wibox.container.background,
    },
    width = 500,
    strategy = "min",
    widget = wibox.container.constraint,
  }),
})

local self = ret.popup

self:connect_signal("unfocus", function()
  self.visible = false
  ret.widget.visible = false
end)

function ret.show()
  self.visible = true
  ret.widget.visible = true
end

function ret.hide()
  self.visible = false
  ret.widget.visible = false
end

function ret.toggle()
  self.visible = not self.visible
end

return ret
