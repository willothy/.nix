local awful = Capi.awful
local beautiful = Capi.beautiful
local dpi = beautiful.xresources.apply_dpi

local gears = Capi.gears
local wibox = Capi.wibox

local cairo = require("lgi").cairo

---@class gears.surface

---@class Previewable: client
---@field prev_content gears.surface?

---@class TaskPreviewConfig
---@field width number
---@field height number
---@field margin number
---@field bg string
---@field border_color string
---@field border_width number
---@field border_radius number
---@field placement_fn function

---@class TaskPreviewOpts
---@field width? number
---@field height? number
---@field margin? number
---@field bg? string
---@field border_color? string
---@field border_width? number
---@field border_radius? number
---@field placement_fn? function

---@class TaskPreview
---@field config TaskPreviewConfig
---@field widget wibox
---@field screen screen
local TaskPreview = {}

---@private
---@param client client
function TaskPreview:draw(client)
  if not pcall(function()
    return type(client.content)
  end) then
    return
  end

  ---@cast client Previewable

  local content = nil
  if client:isvisible() then
    content = gears.surface(client.content)
    client.prev_content = content
  elseif client.prev_content then
    content = gears.surface(client.prev_content)
  end

  local img = nil
  if content ~= nil then
    local cr = cairo.Context(content)
    local x, y, w, h = cr:clip_extents()
    img = cairo.ImageSurface.create(cairo.Format.ARGB32, w - x, h - y)
    cr = cairo.Context(img)
    cr:set_source_surface(content, 0, 0)
    cr.operator = cairo.Operator.SOURCE
    cr:paint()
  end

  local previews = self.widget.widget:get_children_by_id("image_role") --[[@as wibox.widget.imagebox[]?]]
  for _, w in ipairs(previews or {}) do
    w:set_image(img)
  end
  local preview_containers =
    self.widget.widget:get_children_by_id("image_container_role") --[[@as wibox.container.margin[]?]]
  for _, w in ipairs(preview_containers or {}) do
    ---@diagnostic disable-next-line: inject-field
    w.top = img and dpi(5) or 0
  end

  local names = self.widget.widget:get_children_by_id("name_role") --[[@as wibox.widget.textbox[]?]]
  for _, w in ipairs(names or {}) do
    local text = client.name
    if string.len(text) > 25 then
      text = text:sub(1, 25) .. "..."
    end
    w:set_text(text)
  end

  local icons = self.widget.widget:get_children_by_id("icon_role")--[[@as wibox.widget.imagebox[]?]]
  for _, w in ipairs(icons or {}) do
    w:set_image(client.icon)
  end
end

function TaskPreview:show(client)
  -- Update task preview contents
  self:draw(client)

  self.widget.visible = true
end

function TaskPreview:hide()
  self.widget.visible = false
end

function TaskPreview:toggle(client)
  if self.widget.visible then
    self:hide()
  else
    self:show(client)
  end
end

---@param screen screen
---@param opts? TaskPreviewOpts
---@return TaskPreview
function TaskPreview.new(screen, opts)
  opts = opts or {}
  local self = {}

  self.screen = screen

  local width = opts.width or dpi(300)
  local margin = beautiful.task_preview_widget_margin or dpi(0)
  local bg = beautiful.task_preview_widget_bg or "#000000"
  local border_color = beautiful.task_preview_widget_border_color or "#ffffff"
  local border_width = beautiful.task_preview_widget_border_width or dpi(3)
  local border_radius = beautiful.task_preview_widget_border_radius or dpi(0)

  self.widget = awful.popup({
    type = "dropdown_menu",
    visible = false,
    ontop = true,
    placement = opts.placement_fn or function(c)
      awful.placement.top(c, {
        parent = self.screen,
        margins = {
          top = beautiful.bar_height + beautiful.useless_gap * 2,
        },
      })
    end,
    widget = wibox.container.background,
    input_passthrough = true,
    bg = "#00000000",
  })

  local icon_width = dpi(30)
  local icon_height = dpi(30)

  self.widget.widget = wibox.widget({
    {
      {
        {
          {
            {
              {
                id = "icon_role",
                resize = true,
                forced_height = icon_height,
                forced_width = icon_width,
                widget = wibox.widget.imagebox,
              },
              widget = wibox.container.margin,
            },
            {
              {
                id = "name_role",
                font = "Inter 14",
                halign = "center",
                widget = wibox.widget.textbox,
              },
              bottom = dpi(2),
              left = dpi(4),
              right = dpi(4),
              widget = wibox.container.margin,
            },
            {
              {
                id = "blank_role",
                resize = true,
                forced_height = icon_height,
                forced_width = icon_width / 2,
                widget = wibox.widget.imagebox,
              },
              right = 0,
              widget = wibox.container.margin,
            },
            layout = wibox.layout.align.horizontal,
          },
          {
            {
              {
                id = "image_role",
                resize = true,
                clip_shape = require("lib.shape").rounded_rect(border_radius),
                widget = wibox.widget.imagebox,
              },
              valign = "center",
              halign = "center",
              widget = wibox.container.place,
            },
            id = "image_container_role",
            top = 0,
            widget = wibox.container.margin,
          },
          layout = wibox.layout.align.vertical,
        },
        margins = margin,
        widget = wibox.container.margin,
      },
      bg = bg,
      shape_border_width = border_width,
      shape_border_color = border_color,
      shape = require("lib.shape").rounded_rect(border_radius),
      widget = wibox.container.background,
    },
    width = width,
    -- height = height,
    widget = wibox.container.constraint,
  })

  setmetatable(self, {
    __index = TaskPreview,
  })

  return self
end

return TaskPreview
