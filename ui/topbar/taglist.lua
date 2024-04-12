local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local function is_selected(s, index)
  local i = 1
  while i <= #s.selected_tags do
    if s.selected_tags[i].index == index then
      return true, s.selected_tags[i]
    end
    i = i + 1
  end
  return false
end

local function update_tags(self, index, s)
  local markup_role = self:get_children_by_id("markup_role")[1]

  if is_selected(s, index) then
    markup_role.image = gears.color.recolor_image(
      beautiful.selected_tag_format,
      beautiful.taglist_fg_focus
    )
  else
    markup_role.image = gears.color.recolor_image(
      beautiful.normal_tag_format,
      beautiful.taglist_fg
    )
    ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
    for _, c in ipairs(client.get(s)) do
      for _, t in ipairs(c:tags()) do
        if t.index == index then
          markup_role.image = gears.color.recolor_image(
            beautiful.occupied_tag_format,
            beautiful.taglist_fg_occupied
          )
        end
      end
    end
  end
end

local M = {}

function M.new(s)
  local preview = require("ui.tag_preview").new(s)

  return awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    layout = {
      layout = wibox.layout.fixed.horizontal,
      spacing = 6,
    },
    style = {
      shape = function(cr, w, h)
        return gears.shape.rounded_rect(cr, w, h, 5)
      end,
    },
    buttons = {
      awful.button({}, 1, function(t)
        t:view_only()
      end),
      awful.button({}, 3, function(t)
        awful.tag.viewtoggle(t)
      end),
      awful.button({}, 4, function(t)
        awful.tag.viewprev(t.screen)
      end),
      awful.button({}, 5, function(t)
        awful.tag.viewnext(t.screen)
      end),
    },
    widget_template = {
      {
        {
          margins = {
            top = 4,
            bottom = 4,
            left = 4,
            right = 4,
          },
          widget = wibox.container.margin,
          {
            id = "markup_role",
            image = nil,
            valign = "center",
            halign = "center",
            forced_height = 18,
            forced_width = 18,
            widget = wibox.widget.imagebox,
          },
        },
        id = "background_role",
        widget = wibox.container.background,
        shape = function(cr, w, h)
          return gears.shape.rounded_rect(cr, w, h, 6)
        end,
      },
      widget = wibox.container.margin,
      margins = {
        top = 4,
        bottom = 4,
      },
      shape = gears.shape.circle,
      update_callback = function(self, _, index)
        update_tags(self, index, s)
      end,
      ---@param tag tag
      create_callback = function(self, tag, index)
        local timed = require("vendor.rubato").timed({
          duration = 0.25,
          intro = 0.0,
          easing = require("vendor.rubato").easing.linear,
          subscribed = function(pos)
            self.children[1]:set_bg(
              require("lib.color").interpolate(
                beautiful.taglist_bg,
                beautiful.dimblack,
                pos
              )
            )
          end,
          clamp_position = true,
        })

        if tag.selected then
          timed.target = 1
        else
          timed.target = 0
        end

        tag:connect_signal("property::selected", function()
          if tag.selected then
            timed.target = 1
          else
            timed.target = 0
          end
        end)

        self:connect_signal("mouse::enter", function()
          timed.target = 1
          ---@diagnostic disable-next-line: missing-parameter
          if #tag:clients() > 0 then
            preview:show(tag)
          end
        end)

        self:connect_signal("mouse::leave", function()
          preview:hide()
          timed.target = 0
        end)

        update_tags(self, index, s)
      end,
    },
  })
end

return M
