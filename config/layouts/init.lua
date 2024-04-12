local M = {}

local awful = Capi.awful

tag.connect_signal("request::default_layouts", function()
  local deck = require("config.layouts.deck")
  local centered = require("vendor.bling.layout.centered")

  Capi.awful.layout.append_default_layouts({
    Capi.awful.layout.suit.tile,
    deck,
    centered,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.right,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,
    awful.layout.suit.tile.top,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.max,
  })
end)
