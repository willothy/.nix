local M = {}

local awful = Capi.awful
local gears = Capi.gears

local playerctl = require("vendor.bling.signal.playerctl")

local lib = playerctl.lib()

function M.play()
  gears.timer.delayed_call(function()
    lib:play()
  end)
end

function M.pause()
  gears.timer.delayed_call(function()
    lib:pause()
  end)
end

function M.stop()
  gears.timer.delayed_call(function()
    lib:stop()
  end)
end

function M.play_pause()
  gears.timer.delayed_call(function()
    lib:play_pause()
  end)
end

function M.next()
  gears.timer.delayed_call(function()
    lib:next()
  end)
end

function M.previous()
  gears.timer.delayed_call(function()
    lib:previous()
  end)
end

return M
