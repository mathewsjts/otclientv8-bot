macro(250, "Eat Food From Ground", function()
  local player = g_game.getLocalPlayer()

  if not player then
      return
  end

  local playerPos = player:getPosition()

  local tile = g_map.getTile(playerPos)
  
  local foodIDs = {3725, 3577, 3578, 3592, 3593, 3594, 3595, 3600, 3606, 3607, 3610, 3611, 3662, 3723, 3725, 3726, 3727}

  if tile then
    local items = tile:getItems()
    for _, item in ipairs(items) do
      if table.contains(foodIDs, item:getId()) then
        g_game.use(item)
        return
      end
    end
  end
end)