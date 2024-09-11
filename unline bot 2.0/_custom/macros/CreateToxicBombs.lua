local viperStarId = 7366
local smallStoneId = 1781
local minStars = 5
local minManaPercent = 80

macro(1000, "Create Toxic Bombs", function()
  local player = g_game.getLocalPlayer()

  if not player then
    return
  end
  
  if itemAmount(smallStoneId) < 1 then
    return
  end
  
  if itemAmount(viperStarId) < minStars and freecap() >= 10 and manapercent() >= minManaPercent then
    cast("exevo pox morir")
  end
  
  if itemAmount(smallStoneId) >= 1 and itemAmount(viperStarId) >= 5 and manapercent() >= minManaPercent then
    cast("adevo toxicon lumen")
  end
end)
