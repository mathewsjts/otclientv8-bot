local title = "StartSetup"

CaveBot.Extensions[title] = {}

CaveBot.Extensions[title].execute = function(value)
	local data = string.split(value, ",")
	local suppliesData = Supplies.hasEnough()
	local suppliesConfig = Supplies.getAdditionalData()
	local hasBlessings = player:getBlessings() > 0
	local hasRefill = storage.caveBot.forceRefill
										or storage.caveBot.backStop
										or storage.caveBot.backTrainers
										or storage.caveBot.backOffline
										or type(suppliesData) == "table"
										or (suppliesConfig.capacity.enabled and freecap() < tonumber(suppliesConfig.capacity.value))
										or (suppliesConfig.stamina.enabled and stamina() < tonumber(suppliesConfig.stamina.value))

	-- set sell loot cities
	local sellLootCities = {}
	for _, cityName in pairs(data) do
		if cityName:trim() ~= "_" then
			table.insert(sellLootCities, cityName:trim())
		end
	end
	ProfileManager.setSellLoot(sellLootCities)

	-- set active profile and targetbot
	if ProfileManager.getActiveProfile() ~= CaveBot.getCurrentProfile() then
		ProfileManager.setActiveProfile(CaveBot.getCurrentProfile())
	end
	TargetBot.setCurrentProfile(CaveBot.getCurrentProfile())

	-- equip weapon
	if not getLeft() then
		g_game.move(findItem(storage_custom.weapon_id), {x=65535, y=SlotLeft, z=0}, 1)
	end

	if not hasBlessings or hasRefill then
		CaveBot.setCurrentProfile("__configuration")
	end

	CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
	return true
end

CaveBot.Extensions[title].setup = function()
  CaveBot.registerAction(
		title,
		"#ffffff",
		CaveBot.Extensions[title].execute
	)

  CaveBot.Editor.registerAction(
		title,
		title,
		{
			value = "_",
			title = title,
			description="Setup the script",
			multiline=false
		}
	)
end
