local aolId = 3057

macro(250, "Pause CaveBot Without Bless", function()
  local player = g_game.getLocalPlayer()

  if not player then
    return
  end

  local playerIsBlessed = player:getBlessings() > 0

  if playerIsBlessed then
    return
  end

  local aolCount = 0
  local containers = getContainers()

  for _, container in ipairs(containers) do
    for _, item in ipairs(container:getItems()) do
      if item:getId() == aolId then
        aolCount = aolCount + item:getCount()
      end
    end
  end

  if aolCount > 0 and getNeck():getId() ~= aolId then
    g_game.equipItemId(aolId)
  end

  CaveBot.setOff()
end)
