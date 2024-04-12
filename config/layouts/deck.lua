local deck = { name = "deck" }

function deck.arrange(p)
  local area = p.workarea
  local client_count = #p.clients

  if client_count == 1 then
    local c = p.clients[1]
    local g = {
      x = area.x,
      y = area.y,
      width = area.width,
      height = area.height,
    }
    p.geometries[c] = g
    return
  end

  local xoffset = area.width * 0.1 / (client_count - 1)
  local yoffset = area.height * 0.1 / (client_count - 1)

  for idx = 1, client_count do
    local c = p.clients[idx]
    local g = {
      x = area.x + (idx - 1) * xoffset,
      y = area.y + (idx - 1) * yoffset,
      width = area.width - (math.abs(xoffset) * (client_count - 1)),
      height = area.height - (math.abs(yoffset) * (client_count - 1)),
    }
    p.geometries[c] = g
  end
end

return deck
