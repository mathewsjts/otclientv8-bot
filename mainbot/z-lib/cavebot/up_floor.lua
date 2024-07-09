CaveBot.Extensions.UpFloor = {}

CaveBot.Extensions.UpFloor.setup = function()
  CaveBot.registerAction("UpFloor", "#ffffff", function(value, retries)
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
      useWith(storage.extras.rope, tile:getTopUseThing())
      CaveBot.delay(800)
      use(tile:getTopUseThing())
      return "retry"
    end

    CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
    return true
  end)

  CaveBot.Editor.registerAction("UpFloor", "up floor", {
    value=function() return posx()..","..posy()..","..posz() end,
    title="Up floor",
    description="x,y,z",
    multiline=false,
    validation="^\\s*([0-9]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)$"
  })
end
