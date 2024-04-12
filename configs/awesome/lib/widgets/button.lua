local M = {}

local wibox = Capi.wibox
local gears = Capi.gears
local awful = Capi.awful
local beautiful = Capi.beautiful

function M.add_hover(widget, bg, hover_bg)
  local timed = require("vendor.rubato").timed({
    duration = 0.3,
    intro = 0.0,
    easing = require("vendor.rubato").easing.linear,
    subscribed = function(pos)
      widget.bg = require("lib.color").interpolate(bg, hover_bg, pos)
    end,
    clamp_position = true,
  })

  widget:connect_signal("mouse::enter", function()
    timed.target = 1
  end)
  widget:connect_signal("mouse::leave", function()
    timed.target = 0
  end)
end

---@param widget any
---@param text string
---@param placement any?
---@return any
function M.add_tooltip(widget, text, placement)
  local tooltip = require("lib.widgets.tooltip").new(
    text,
    placement
      or awful.placement.top_right(widget, {
        margins = {
          top = beautiful.bar_height + (beautiful.useless_gap * 2),
          right = beautiful.useless_gap * 2,
        },
      })
  )
  widget:connect_signal("mouse::enter", function()
    tooltip.visible = true
  end)
  widget:connect_signal("mouse::leave", function()
    tooltip.visible = false
  end)
  return tooltip
end

function M.new(template, bg, hover_bg, radius)
  radius = radius or 6
  local self = wibox.widget({
    {
      template,
      margins = 7,
      widget = wibox.container.margin,
    },
    bg = bg,
    widget = wibox.container.background,
    shape = function(cr, w, h)
      return gears.shape.rounded_rect(cr, w, h, radius)
    end,
  })

  if bg and hover_bg then
    M.add_hover(self, bg, hover_bg)
  end

  return self
end

return M
