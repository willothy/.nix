local M = {}

local gears = Capi.gears

function M.ensure_rgba(str)
  if #str <= 7 then
    str = str .. "ff"
  end
  return str
end

function M.hex_to_int(str)
  return tonumber(str:gsub("#", ""), 16)
end

function M.int_to_hex(int)
  if type(int) == "string" then
    return int
  end
  return string.format("#%08x", int)
end

local bit
---@diagnostic disable-next-line: undefined-field
if _G.jit then
  bit = require("bit")
else
  bit = require("lib.no_luajit").bit
end

function M.interpolate(color1, color2, bias, depth)
  bias = bias or 0.5
  depth = depth or 0

  local r1, g1, b1, a1 = gears.color.parse_color(color1)
  local r2, g2, b2, a2 = gears.color.parse_color(color2)

  -- The color parser returns values between 0 and 1
  r1, g1, b1, a1 = r1 * 255, g1 * 255, b1 * 255, a1 * 255
  r2, g2, b2, a2 = r2 * 255, g2 * 255, b2 * 255, a2 * 255

  local ok, rgba = pcall(function()
    local r = math.floor((r2 - r1) * bias + r1) or 0
    local g = math.floor((g2 - g1) * bias + g1) or 0
    local b = math.floor((b2 - b1) * bias + b1) or 0
    local a = math.floor((a2 - a1) * bias + a1) or 0

    return bit.bor(
      bit.bor(bit.lshift(r, 24), bit.lshift(g, 16)),
      bit.bor(bit.lshift(b, 8), a)
    )
  end)

  -- sometimes the color parser fails, so we try again
  -- but if it fails again, we just return the original color
  if depth < 3 and not ok then
    return M.interpolate(color1, color2, bias, depth + 1)
  end

  if not ok then
    return color1
  end

  return M.int_to_hex(rgba)
end

return M
