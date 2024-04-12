local M = {}

local main_menu = Capi.awful.menu({
  items = {
    { "Terminal", Programs.terminal },
    { "Explorer", Programs.explorer },
    { "Browser", Programs.browser },
    { "Restart", awesome.restart },
    {
      "Logout",
      function()
        awesome.quit()
      end,
    },
  },
})

function M.toggle()
  main_menu:toggle()
end

function M.show()
  main_menu:show()
end

function M.hide()
  main_menu:hide()
end

return M
