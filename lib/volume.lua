local M = {}

local awful = Capi.awful

local function clamp(n)
  return math.min(1.0, math.max(n or 0, 0.0))
end

function M.set(percent)
  percent = clamp(percent or 0)
  awful.spawn.with_shell(
    "amixer -D pulse sset Master " .. math.floor(percent * 100) .. "%"
  )
  awesome.emit_signal("volume::change", percent)
end

function M.mute()
  awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
  awful.spawn.easy_async_with_shell(
    "pactl get-sink-mute @DEFAULT_SINK@",
    function(stdout)
      local res = string.match(stdout, "Mute: %s+")
      if not res then
        return
      end
      if res == "yes" then
        awesome.emit_signal("volume::mute", true)
      else
        awesome.emit_signal("volume::mute", false)
      end
    end
  )
end

function M.increase(amount)
  amount = clamp(amount or 0.05)
  awful.spawn.easy_async_with_shell(
    "bash -c amixer -D pulse sget Master",
    function(stdout)
      local volume = string.match(stdout, "(%d?%d?%d)%%")
      if not volume then
        return
      end
      volume = tonumber(volume)
      if not volume then
        return
      end
      local new_volume = (volume / 100) + amount
      M.set(new_volume)
      awesome.emit_signal("volume::change", new_volume)
    end
  )
end

function M.decrease(amount)
  amount = clamp(amount or 0.05)
  awful.spawn.easy_async_with_shell(
    "bash -c amixer -D pulse sget Master",
    function(stdout)
      local volume = string.match(stdout, "(%d?%d?%d)%%")
      if not volume then
        return
      end
      volume = tonumber(volume)
      if not volume then
        return
      end
      local new_volume = (volume / 100) - amount
      M.set(new_volume)
      awesome.emit_signal("volume::change", new_volume)
    end
  )
end

return M
