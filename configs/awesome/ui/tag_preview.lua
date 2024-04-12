local awful = Capi.awful
local beautiful = Capi.beautiful
local dpi = beautiful.xresources.apply_dpi

local gears = Capi.gears
local wibox = Capi.wibox

local cairo = require("lgi").cairo

---@class TagPreviewConfig
---@field scale number
---@field tag_preview_image boolean
---@field width number
---@field margin number
---@field client_bg string
---@field client_border_color string
---@field client_border_width number
---@field client_border_radius number
---@field widget_bg string
---@field widget_border_color string
---@field widget_border_width number
---@field widget_border_radius number

---@class TagPreviewOpts
---@field scale? number
---@field tag_preview_image? boolean
---@field width? number
---@field margin? number
---@field client_bg? string
---@field client_border_color? string
---@field client_border_width? number
---@field client_border_radius? number
---@field widget_bg? string
---@field widget_border_color? string
---@field widget_border_width? number
---@field widget_border_radius? number

---@class TagPreview
---@field config TagPreviewConfig
---@field widget wibox
---@field screen screen
---@field client_list wibox.layout.manual
local TagPreview = {}

---@private
---@param tag tag
function TagPreview:draw(tag)
  local geo = self.screen:get_bounding_geometry({
    honor_workarea = false,
    honor_padding = false,
  })
  local scale = self.config.scale
  local tag_preview_image = self.config.tag_preview_image

  local client_list = self.client_list

  local clients = {}

  ---@diagnostic disable-next-line: missing-parameter
  for _, c in ipairs(tag:clients()) do
    ---@cast c Previewable
    if not c.hidden and not c.minimized then
      local img_box = wibox.widget({
        resize = true,
        forced_height = 35,
        forced_width = 35,
        widget = wibox.widget.imagebox,
      }) --[[@as wibox.widget.imagebox]]

      img_box:set_image(
        gears.surface.load_silently(
          c.icon,
          beautiful.theme_assets.awesome_icon(24, "#222222", "#fafafa")
        )
      )

      if tag_preview_image and (c.prev_content or tag.selected) then
        local content
        if tag.selected then
          content = gears.surface(c.content)
        elseif c.prev_content then
          content = gears.surface(c.prev_content)
        end
        local cr = cairo.Context(content)
        local x, y, w, h = cr:clip_extents()
        local img =
          cairo.ImageSurface.create(cairo.Format.ARGB32, w - x, h - y)
        cr = cairo.Context(img)
        cr:set_source_surface(content, 0, 0)
        cr.operator = cairo.Operator.SOURCE
        cr:paint()

        ---@diagnostic disable-next-line: undefined-field
        local surface = gears.surface.load_silently(img, img_box.image)
        img_box:set_image(surface)
        img_box:set_forced_height(math.floor(c.height * scale))
        img_box:set_forced_width(math.floor(c.width * scale))
      end

      local client_box = wibox.widget({
        {
          nil,
          {
            nil,
            img_box,
            nil,
            expand = "outside",
            layout = wibox.layout.align.horizontal,
          },
          nil,
          expand = "outside",
          widget = wibox.layout.align.vertical,
        },
        forced_height = math.floor(c.height * scale),
        forced_width = math.floor(c.width * scale),
        bg = self.config.client_bg,
        border_color = self.config.client_border_color,
        border_width = self.config.client_border_width,
        shape = require("lib.shape").rounded_rect(
          self.config.client_border_radius
        ),
        widget = wibox.container.background,
      }) --[[@as wibox.container.background]]

      ---@diagnostic disable-next-line: inject-field
      client_box.point = {
        x = math.floor((c.x - geo.x) * scale) + (beautiful.useless_gap * 2),
        y = math.floor((c.y - geo.y) * scale),
      }

      table.insert(clients, client_box)
    end
  end
  client_list:set_children(clients)
end

function TagPreview:show(tag)
  -- Update tag preview contents
  self:draw(tag)

  self.widget.visible = true
end

function TagPreview:hide()
  self.widget.visible = false
end

function TagPreview:toggle(tag)
  if self.widget.visible then
    self:hide()
  else
    self:show(tag)
  end
end

---@param screen screen
---@param opts? TaskPreviewOpts
---@return TaskPreview
function TagPreview.new(screen, opts)
  opts = opts or {}
  local self = {}

  self.screen = screen

  local margin = beautiful.tag_preview_widget_margin or dpi(0)

  self.config = {
    tag_preview_image = false,
    width = dpi(300),
    margin = margin,
    client_bg = beautiful.tag_preview_client_bg or "#000000",
    client_border_color = beautiful.tag_preview_client_border_color
      or "#ffffff",
    client_border_width = beautiful.tag_preview_client_border_width or dpi(3),
    client_border_radius = beautiful.tag_preview_client_border_radius
      or dpi(0),
    client_opacity = beautiful.tag_preview_client_opacity or 0.5,
    widget_bg = beautiful.tag_preview_widget_bg or "#000000",
    widget_border_color = beautiful.tag_preview_widget_border_color
      or "#ffffff",
    widget_border_width = beautiful.tag_preview_widget_border_width or dpi(3),
    widget_border_radius = beautiful.tag_preview_widget_border_radius
      or dpi(0),
    widget_x = beautiful.useless_gap * 2,
    widget_y = beautiful.bar_height + (beautiful.useless_gap * 2),
    scale = 0.2,
  }

  self.widget = awful.popup({
    type = "dropdown_menu",
    visible = false,
    ontop = true,
    placement = function(c)
      awful.placement.top_left(c, {
        parent = self.screen,
        margins = {
          left = beautiful.useless_gap * 2,
          top = beautiful.bar_height + beautiful.useless_gap * 2,
        },
      })
    end,
    widget = wibox.container.background,
    input_passthrough = true,
    bg = "#00000000",
  })

  local geo = screen:get_bounding_geometry({
    honor_workarea = false,
    honor_padding = false,
  })

  ---@diagnostic disable-next-line: inject-field
  self.widget.maximum_width = self.config.scale * geo.width
    + (self.config.margin or 0) * 2
  ---@diagnostic disable-next-line: inject-field
  self.widget.maximum_height = self.config.scale * geo.height
    + (self.config.margin or 0)

  self.widget.x = self.screen.geometry.x
  self.widget.y = self.screen.geometry.y

  self.client_list = wibox.layout.manual()

  self.widget.widget = wibox.widget({
    {
      self.client_list,
      forced_height = geo.height,
      forced_width = geo.width,
      widget = wibox.container.place,
      align = "center",
      halign = "center",
      valign = "center",
    },
    bgimage = beautiful.wallpaper,
    bg = self.config.widget_bg,
    border_width = self.config.widget_border_width,
    border_color = self.config.widget_border_color,
    border_strategy = "inner",
    shape = require("lib.shape").rounded_rect(
      self.config.widget_border_radius
    ),
    widget = wibox.container.background,
  })

  setmetatable(self, {
    __index = TagPreview,
  })

  return self
end

return TagPreview
