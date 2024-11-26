CaveBot.Extensions.ChangeFloor2 = {}

CaveBot.Extensions.ChangeFloor2.setup = function()
  CaveBot.registerAction("ChangeFloor2", "#ffffff", function(value, retries)
    local data = regexMatch(value, "\\s*([a-z]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)")
    local direction = data[1][2]
    local tilePosition = {x=tonumber(data[1][3]), y=tonumber(data[1][4]), z=tonumber(data[1][5])}
    local playerPosition = player:getPosition()

    if retries > 10 then
      return false
    end

    if playerPosition.z == tilePosition.z and getDistanceBetween(playerPosition, tilePosition) >= 5 then
      autoWalk(tilePosition, 100, {precision=2})
      return "retry"
    end

    if playerPosition.z == tilePosition.z then
      local tile = g_map.getTile(tilePosition)
      local topUseThing = tile:getTopUseThing()

      if direction == "up" then
				autoWalk(tilePosition, 100, {precision=0})
        CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
        cast("exani tera")
        return "retry"
      elseif direction == "down" then
				useWith(storage.extras.shovel, topUseThing)
				CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
				use(topUseThing)
				CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
        autoWalk(tilePosition, 100, {precision=0})
        return "retry"
      end
    end

    CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
    return true
  end)

  CaveBot.Editor.registerAction("changefloor2", "change floor2", {
    value=function() return "up,"..posx()..","..posy()..","..posz() end,
    title="Change floor",
    description="up/down,x,y,z",
    multiline=false,
    validation="^\\s*([a-z]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)$"
  })
end
