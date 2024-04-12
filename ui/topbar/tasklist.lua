---@class TaskList
local TaskList = {}

local awful = Capi.awful
local wibox = Capi.wibox
local beautiful = Capi.beautiful

client.connect_signal("request::manage", function(c)
  beautiful.icon_theme:get_client_icon_path(c, function(icon)
    local surface = Capi.gears.surface(icon)
    c.icon = surface._native
  end)
end)

---@param screen screen
function TaskList.new(screen)
  local preview = require("ui.task_preview").new(screen)

  return awful.widget.tasklist({
    screen = screen,
    filter = awful.widget.tasklist.filter.currenttags,
    source = function()
      ---@param a client
      ---@param b client
      return table.sort(screen.all_clients, function(a, b)
        return a.name < b.name
      end)
    end,
    buttons = {
      awful.button({}, 1, function(c)
        if not c.active then
          c:activate({
            context = "through_dock",
            switch_to_tag = true,
          })
        else
          c.minimized = true
        end
      end),
      awful.button({}, 4, function()
        awful.client.focus.byidx(-1)
      end),
      awful.button({}, 5, function()
        awful.client.focus.byidx(1)
      end),
    },
    layout = {
      spacing = 10,
      layout = wibox.layout.fixed.horizontal,
    },
    widget_template = {
      {
        {
          {
            id = "clienticon",
            widget = awful.widget.clienticon,
            resize = true,
          },
          margins = 1,
          widget = wibox.container.margin,
        },
        widget = wibox.container.background,
        shape = require("lib.shape").rounded_rect(5),
      },
      margins = -3,
      widget = wibox.container.margin,
      create_callback = function(self, c, _idx, _clients)
        self:get_children_by_id("clienticon")[1].client = c

        local timed = require("vendor.rubato").timed({
          duration = 0.3,
          intro = 0.0,
          easing = require("vendor.rubato").easing.linear,
          subscribed = function(pos)
            self.children[1].bg = require("lib.color").interpolate(
              beautiful.bg_normal,
              beautiful.bg_focus,
              pos
            )
          end,
          clamp_position = true,
          awestore_compat = true,
        })

        if c.active then
          timed.target = 1
        else
          timed.target = 0
        end

        c:connect_signal("focus", function()
          timed.target = 1
        end)

        local calling = false
        c:connect_signal("mouse::move", function()
          if calling then
            return
          end
          calling = true
          Capi.gears.timer.delayed_call(function()
            timed.target = 1
            calling = false
          end)
        end)

        c:connect_signal("unfocus", function()
          timed.target = 0
        end)

        self:connect_signal("mouse::enter", function()
          timed.target = 1
          preview:show(c)
        end)

        self:connect_signal("mouse::leave", function()
          timed.target = 0
          preview:hide()
        end)
      end,
    },
  })
end

return TaskList
