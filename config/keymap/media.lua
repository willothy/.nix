local awful = Capi.awful

awful.keyboard.append_global_keybindings({
  -- Volume Controls
  awful.key({}, "XF86AudioRaiseVolume", function()
    require("lib.volume").increase()
  end, { description = "Raise volume", group = "media" }),
  awful.key({}, "XF86AudioLowerVolume", function()
    require("lib.volume").decrease()
  end, { description = "Lower volume", group = "media" }),
  awful.key({}, "XF86AudioMute", function()
    require("lib.volume").mute()
  end, { description = "Mute volume", group = "media" }),

  -- Media Controls
  awful.key({}, "XF86AudioPlay", function()
    require("lib.playerctl").play_pause()
  end, { description = "Play/pause", group = "media" }),
  awful.key({}, "XF86AudioNext", function()
    require("lib.playerctl").next()
  end, { description = "Next", group = "media" }),
  awful.key({}, "XF86AudioPrev", function()
    require("lib.playerctl").previous()
  end, { description = "Previous", group = "media" }),

  awful.key({}, "XF86MonBrightnessUp", function()
    require("lib.brightnessctl").increase()
  end, { description = "Brightness up", group = "system" }),
  awful.key({}, "XF86MonBrightnessDown", function()
    require("lib.brightnessctl").decrease()
  end, { description = "Brightness down", group = "system" }),
})
