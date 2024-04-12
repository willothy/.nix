local M = {}

local MSG_FMT = [[
  <b>screens (%d)</b>:
    %s

  <b>primary</b>:
    %s
  ]]

local SCR_FMT = "%d: %dx%d @ %d, %d"

-- TODO: xrandr wrapper of some sort to set this shit up automatically like arandr does manually.
-- I HATE CONFIGURING SCREENS.
-- I really don't want to have to run arandr on startup or keep tweaking xrandr scripts.
-- It sucks.

---Return an iterator over all screens
function M.screens()
  local i = 1
  local max = screen.instances() --[[@as integer]]
  return function()
    if i <= max then
      local s = screen[i]
      i = i + 1
      return s
    end
  end
end

function M.screen_info(index)
  local s = screen[index]
  if not s then
    return nil
  end
  return {
    index = index,
    dpi = s.dpi,
    primary = index == screen.primary.index,
    geometry = s.geometry,
    workarea = s.workarea,
  }
end

function M.fmt_screen_info(index)
  local s = screen[index]
  if not s then
    return ("no such screen %d"):format(index)
  end
  return SCR_FMT:format(
    s.index,
    s.geometry.width,
    s.geometry.height,
    s.geometry.x,
    s.geometry.y
  )
end

function M.print_screen_info(opts)
  opts = opts or {}

  local screens = {}
  for screen in M.screens() do
    table.insert(screens, M.fmt_screen_info(screen.index))
  end
  Capi.naughty.notify({
    title = "Screens",
    text = MSG_FMT:format(
      screen.instances(),
      table.concat(screens, "\n"),
      screen.primary and screens[screen.primary.index] or "none"
    ),
    -- 30 second default timeout since it's debug info and I prob want to read it
    timeout = opts.timeout or 30,
  })
end

return M
