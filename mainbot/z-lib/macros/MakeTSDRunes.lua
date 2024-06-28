local tsdRuneId = 3160
local makingTsd = false

macro(1000, "Make TSD Runes", function()
  local player = g_game.getLocalPlayer()

  if not player then
    return
  end

  local tsdCount = 0
  local containers = getContainers()

  for _, container in ipairs(containers) do
    for _, item in ipairs(container:getItems()) do
      if item:getId() == tsdRuneId then
        tsdCount = tsdCount + item:getCount()
      end
    end
  end

  if tsdCount < 100 and not makingTsd then
    cast("adori mas vis")
    makingTsd = true

  elseif tsdCount >= 400 and makingTsd then
    makingTsd = false
  end
end)