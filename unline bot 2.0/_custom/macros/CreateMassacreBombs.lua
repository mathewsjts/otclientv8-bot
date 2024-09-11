local throwingStarId = 3287
local viperStarId = 7366
local assassinStarId = 7368
local smallStoneId = 1781
local minStars = 5
local minManaPercent = 80

macro(1000, "Create Massacre Bombs", function()
  local player = g_game.getLocalPlayer()

  if not player then
    return
  end
  
  if itemAmount(smallStoneId) < 1 then
    return
  end
  
  if itemAmount(throwingStarId) < minStars and freecap() >= 10 and manapercent() >= minManaPercent then
    cast("exevo morir")
  end
  
  if itemAmount(viperStarId) < minStars and freecap() >= 10 and manapercent() >= minManaPercent then
    cast("exevo pox morir")
  end
  
  if itemAmount(assassinStarId) < minStars and freecap() >= 10 and manapercent() >= minManaPercent then
    cast("exevo mas morir")
  end

  if itemAmount(smallStoneId) >= 1 and itemAmount(throwingStarId) >= 5 and itemAmount(viperStarId) >= 5 and itemAmount(assassinStarId) >= 5 and manapercent() >= minManaPercent then
    cast("adevo eversio")
  end
end)
