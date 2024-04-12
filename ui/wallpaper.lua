local M = {}

function M.set(wallpaper, screen)
  ---@diagnostic disable-next-line: deprecated
  Capi.gears.wallpaper.maximized(wallpaper, screen, false, { x = 0, y = 0 })
end

screen.connect_signal("request::wallpaper", function(s)
  M.set(Capi.beautiful.wallpaper, s)
end)

return M
