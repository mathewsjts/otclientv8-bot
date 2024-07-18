local lifeRingThresholdAdd = 3
local lifeRingThresholdRemove = 6

local lootLifeRing = false

macro(3000, "Manage Life Rings", function()
  local containers = getContainers()

  if not containers then
    return
  end

  local lifeRingCount = 0
  for _, container in ipairs(containers) do
    for _, item in ipairs(container:getItems()) do
      if item:getId() == 3052 then
        lifeRingCount = lifeRingCount + item:getCount()
      end
    end
  end

  if lifeRingCount < lifeRingThresholdAdd and not lootLifeRing then
    g_game.talk("!quickloot add,life ring")
    lootLifeRing = true
  elseif lifeRingCount >= lifeRingThresholdRemove and lootLifeRing then
    g_game.talk("!quickloot remove,life ring")
    lootLifeRing = false
  end
end)
