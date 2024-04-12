local bling = require("vendor.bling")
local rubato = require("vendor.rubato")

local scratchpad = bling.module.scratchpad({
  command = "wezterm start --class spad",
  rule = { instance = "spad" },
  sticky = true,
  autoclose = true,
  floating = true,
  geometry = { x = 0, y = 0, height = 400, width = 2560 },
  reapply = true,
  dont_focus_before_close = false,
  rubato = {
    y = rubato.timed({
      pos = -400,
      rate = 60,
      easing = rubato.quadratic,
      intro = 0.1,
      duration = 0.3,
      awestore_compat = true,
    }),
  },
})

-- Override the default behavior of the scratchpad to center it on the primary screen instead
-- of the focused one.
local apply = scratchpad.apply
function scratchpad:apply(c)
  if not c or not c.valid then
    return
  end
  apply(self, c)
  c:geometry({
    x = self.geometry.x + screen.primary.geometry.x,
    y = self.geometry.y + screen.primary.geometry.y,
  })
end

local M = {}

function M.toggle()
  scratchpad:toggle()
end

function M.open()
  scratchpad:turn_on()
end

function M.close()
  scratchpad:turn_off()
end

return M
