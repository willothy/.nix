local M = {}

local gears = Capi.gears

function M.rounded_rect(radius)
  return function(cr, w, h)
    return gears.shape.rounded_rect(cr, w, h, radius)
  end
end

function M.partially_rounded_rect(radius, tl, tr, br, bl)
  return function(cr, w, h)
    return gears.shape.partially_rounded_rect(cr, w, h, tl, tr, br, bl, radius)
  end
end

return M
