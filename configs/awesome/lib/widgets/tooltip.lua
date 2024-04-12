local M = {}

local awful = Capi.awful
local wibox = Capi.wibox
local beautiful = Capi.beautiful

function M.new(text, placement)
  local ret = {}

  ret.widget = wibox.widget({
    {
      {
        id = "image",
        image = beautiful.hints_icon,
        forced_height = 12,
        forced_width = 12,
        halign = "center",
        valign = "center",
        widget = wibox.widget.imagebox,
      },
      {
        id = "text",
        markup = text or "",
        align = "center",
        widget = wibox.widget.textbox,
      },
      spacing = 7,
      layout = wibox.layout.fixed.horizontal,
    },
    margins = 12,
    widget = wibox.container.margin,
    set_text = function(self, t)
      self:get_children_by_id("text")[1].markup = t
    end,
    set_image = function(self, i)
      self:get_children_by_id("image")[1].image = i
    end,
  })

  ret.popup = awful.popup({
    visible = false,
    shape = require("lib.shape").rounded_rect(),
    bg = beautiful.bg_normal .. "00",
    fg = beautiful.fg_normal,
    ontop = true,
    placement = placement or awful.placement.centered,
    screen = awful.screen.focused(),
    widget = wibox.widget({
      ret.widget,
      shape = require("lib.shape").rounded_rect(),
      bg = beautiful.bg_normal,
      widget = wibox.container.background,
    }),
  })

  local self = ret.popup

  function ret.set_text(t)
    ---@diagnostic disable-next-line: undefined-field
    ret.widget:set_text(t)
  end

  function ret.set_image(i)
    ---@diagnostic disable-next-line: undefined-field
    ret.widget:set_image(i)
  end

  function ret.show()
    self.visible = true
  end

  function ret.hide()
    self.visible = false
  end

  function ret.toggle()
    if self.visible then
      ret.hide()
    else
      ret.show()
    end
  end

  function ret.move_to_screen(s)
    s = s or awful.screen.focused()
    self.screen = s
  end

  function ret.attach_to_object(object)
    object:connect_signal("mouse::enter", ret.show)
    object:connect_signal("mouse::leave", ret.hide)
  end

  return ret
end

return M
