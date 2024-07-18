CaveBot.Extensions.DownFloor = {}

CaveBot.Extensions.DownFloor.setup = function()
  CaveBot.registerAction("DownFloor", "#ffffff", function(value, retries)
    local data = regexMatch(value, "\\s*([0-9]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)")

    local playerPosition = player:getPosition()
    local targetPosition = {
      x = tonumber(data[1][1]),
      y = tonumber(data[1][2]),
      z = tonumber(data[1][3]),
    }

    if retries > 10 then
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

    if isSameZPosition then
      useWith(storage.extras.shovel, tile:getTopUseThing())
      CaveBot.delay(800)
      autoWalk(targetPosition, 100, {precision = 0})
      return "retry"
    end

    CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
    return true
  end)

  CaveBot.Editor.registerAction("DownFloor", "down floor", {
    value=function() return posx()..","..posy()..","..posz() end,
    title="Down floor",
    description="x,y,z",
    multiline=false,
    validation="^\\s*([0-9]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)$"
  })
end
