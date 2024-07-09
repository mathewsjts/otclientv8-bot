CaveBot.Extensions.HiddenHole = {}

CaveBot.Extensions.HiddenHole.setup = function()
  CaveBot.registerAction("HiddenHole", "#ffffff", function(value, retries)
    local data = regexMatch(value, "\\s*([0-9]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)")

    local holeId = tonumber(data[1][1])
    local playerPosition = player:getPosition()
    local targetPosition = {
      x = tonumber(data[1][2]),
      y = tonumber(data[1][3]),
      z = tonumber(data[1][4]),
    }

    if retries > 30 then
      return false
    end

    local isSameZPosition = playerPosition.z == targetPosition.z
    local isPlayerDistant = getDistanceBetween(playerPosition, targetPosition) >= 5

    if isSameZPosition and isPlayerDistant then
      autoWalk(targetPosition, 100, {precision = 2})
      return "retry"
    end


    local tile = g_map.getTile(targetPosition)
    if not tile then return false end

    useWith(storage.extras.shovel, tile:getTopUseThing())
    CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping") + 600)

    for _, item in ipairs(tile:getItems()) do
      if item:getId() == holeId then
        autoWalk(targetPosition, 100, {precision = 0})
        CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
        return true
      end
    end


    CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
    return "retry"
  end)

  CaveBot.Editor.registerAction("HiddenHole", "hidden hole", {
    value=function() return posx()..","..posy()..","..posz() end,
    title="Hidden hole",
    description="holeId,x,y,z",
    multiline=false,
    validation="^\\s*([0-9]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)$"
  })
end
