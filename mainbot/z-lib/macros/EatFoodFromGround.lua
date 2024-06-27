macro(250, "Eat Food From Ground", function()
  local player = g_game.getLocalPlayer()

  -- Verifica se o jogador está conectado
  if not player then
      return
  end

  -- Posição atual do jogador
  local playerPos = player:getPosition()

  -- Obtém o tile na posição atual do jogador
  local tile = g_map.getTile(playerPos)
  
  -- Lista de IDs de comida (ajuste conforme necessário)
  local foodIDs = {3725, 3577, 3578, 3592, 3593, 3594, 3595, 3600, 3606, 3607, 3610, 3611, 3662, 3723, 3725, 3726, 3727}

  -- Verifica se há itens no tile
  if tile then
      local items = tile:getItems()
      for _, item in ipairs(items) do
          -- Verifica se o item é comida
          if table.contains(foodIDs, item:getId()) then
              -- Usa o item (come a comida)
              g_game.use(item)
              return
          end
      end
  end
end)