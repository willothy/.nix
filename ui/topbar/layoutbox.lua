local wibox = Capi.wibox
local awful = Capi.awful
local beautiful = Capi.beautiful

local M = {}

function M.layout_name(s)
  return require("lib.string").capitalize(awful.layout.get(s).name)
end

function M.new(s)
  local layoutbox = awful.widget.layoutbox({
    screen = s,
    buttons = {
      awful.button({}, 1, function()
        awful.layout.inc(1)
      end),
      awful.button({}, 3, function()
        awful.layout.inc(-1)
      end),
      awful.button({}, 4, function()
        awful.layout.inc(-1)
      end),
      awful.button({}, 5, function()
        awful.layout.inc(1)
      end),
    },
    valign = "center",
    halign = "center",
  })

  layoutbox._layoutbox_tooltip:remove_from_object(layoutbox)

  local tooltip = require("lib.widgets.button").add_tooltip(
    layoutbox, --
    M.layout_name(s),
    function(d)
      return awful.placement.top_right(d, {
        parent = s,
        margins = {
          top = beautiful.bar_height + (beautiful.useless_gap * 2),
          right = beautiful.useless_gap * 2,
        },
      })
    end
  )

  tooltip.attach_to_object(layoutbox)

  ---@diagnostic disable-next-line: param-type-mismatch
  tag.connect_signal("property::selected", function()
    tooltip.set_text(M.layout_name(s))
  end)
  ---@diagnostic disable-next-line: param-type-mismatch
  tag.connect_signal("property::layout", function()
    tooltip.set_text(M.layout_name(s))
  end)

  local layout_indicator = wibox.widget({
    layoutbox,
    wintype = "tooltip",
    widget = wibox.container.margin,
    valign = "center",
    halign = "center",
    margins = {
      top = 2,
      bottom = 2,
    },
  })

  return layout_indicator
end

return M
