local M = {}

local awful = Capi.awful

local BACKLIGHT = "intel_backlight"

local function command(cmd, ...)
  local nvarargs = select("#", ...)
  return string.format(
    "brightnessctl -d %s %s" .. string.rep(" %s", nvarargs),
    BACKLIGHT,
    cmd,
    ...
  )
end

function M.set(percent)
  if percent == nil or percent > 1.0 or percent < 0.0 then
    return
  end

  awful.spawn.with_shell(command("set", math.floor(percent * 100) .. "%"))
end

function M.increase(percent)
  if percent and type(percent) ~= "number" then
    percent = nil
  end
  percent = percent or 0.05
  if percent > 1.0 or percent < 0.0 then
    return
  end
  awful.spawn.with_shell(
    command("set", "+" .. math.floor(percent * 100) .. "%")
  )
end

function M.decrease(percent)
  if percent and type(percent) ~= "number" then
    percent = nil
  end
  percent = percent or 0.05
  if percent > 1.0 or percent < 0.0 then
    return
  end
  awful.spawn.with_shell(command("set", math.floor(percent * 100) .. "%-"))
end

return M
