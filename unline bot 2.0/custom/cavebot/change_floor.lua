local title = "ChangeFloor"

CaveBot.Extensions[title] = {}

CaveBot.Extensions[title].execute = function(value, retries)
	local data = regexMatch(value, "\\s*(up|down)\\s*,\\s*(true|false)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)")
	local direction, useItem = data[1][2], to_boolean(data[1][3])
	local playerPosition = player:getPosition()
	local targetPosition = {x = tonumber(data[1][4]), y = tonumber(data[1][5]), z = tonumber(data[1][6])}

	if retries > 10 then
		return false
	end

	if playerPosition.z == targetPosition.z then
		if getDistanceBetween(playerPosition, targetPosition) >= 5 then
			autoWalk(targetPosition, 100, {precision = 2})
			return "retry"
		end

		local tile = g_map.getTile(targetPosition)
		local topUseThing = tile:getTopUseThing()
		if useItem then
			if direction == "up" then
				useWith(storage.extras.rope, topUseThing)
			else
				useWith(storage.extras.shovel, topUseThing)
				CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
				autoWalk(targetPosition, 100, {precision = 0})
			end
		else
			use(topUseThing)
		end
		return "retry"
	end

	CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
	return true
end

CaveBot.Extensions.ChangeFloor.setup = function()
  CaveBot.registerAction(
		title,
		"#ffffff",
		CaveBot.Extensions[title].execute
	)

  CaveBot.Editor.registerAction(
		title,
		title,
		{
			value = function() return "up,true,"..posx()..","..posy()..","..posz() end,
			title = title,
			description = "up/down, use rope/shovel, x, y, z",
			multiline = false,
			validation = "^\\s*(up|down)\\s*,\\s*(true|false)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)\\s*,\\s*([0-9]+)$"
		}
	)
end
