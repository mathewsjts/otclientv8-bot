local title = "DepositItems"

CaveBot.Extensions[title] = {}

local lootTable = nil
local destination = nil
local reopenedContainers = false

local function resetCache()
	lootTable = nil
	destination = nil
	reopenedContainers = false

	for i, container in ipairs(getContainers()) do
		if container:getName():lower():find("depot") or container:getName():lower():find("locker") then
			g_game.close(container)
		end
	end

	if storage.caveBot.backStop then
		storage.caveBot.backStop = false
		CaveBot.setOff()
	elseif storage.caveBot.backTrainers then
		storage.caveBot.backTrainers = false
		CaveBot.gotoLabel('toTrainers')
	elseif storage.caveBot.backOffline then
		storage.caveBot.backOffline = false
		CaveBot.gotoLabel('toOfflineTraining')
	elseif storage.caveBot.forceRefill then
		storage.caveBot.forceRefill = false
	end
end

CaveBot.Extensions[title].execute = function(value, retries)
	if g_game.getClientVersion() < 960 then
		resetCache()
		warn("CaveBot[Depositor]: unsupported Tibia version, will be added in near future")
		return false
	end

	lootTable = lootTable or CaveBot.GetLootItems()
	if #lootTable == 0 then
		print("CaveBot[Depositor]: no items in loot list. Wrong TargetBot Config? Proceeding")
		resetCache()
		return true
	end

	delay(70)

	if value:lower() == "yes" then
		if not reopenedContainers then
			CaveBot.CloseAllLootContainers()
			delay(3000)
			reopenedContainers = true
			return "retry"
		end
		if not CaveBot.HasLootItems() then
			local lootContainers = CaveBot.GetLootContainers()
			for _, container in ipairs(getContainers()) do
				local cId = container:getContainerItem():getId()
				if table.find(lootContainers, cId) then
					for i, item in ipairs(container:getItems()) do
						if item:getId() == cId then
							g_game.open(item, container)
							delay(100)
							return "retry"
						end
					end
				end
			end
			print("CaveBot[Depositor]: all items stashed, no backpack to open next, proceeding")
			CaveBot.CloseAllLootContainers()
			delay(3000)
			resetCache()
			return true
		end
	end

	if retries == 0 then
		if not CaveBot.HasLootItems() then
			print("CaveBot[Depositor]: no items to stash, proceeding")
			resetCache()
			return true
		end
	end

	if retries > 400 then
		print("CaveBot[Depositor]: Depositor actions limit reached, proceeding")
		resetCache()
		return false
	end

	if not CaveBot.ReachAndOpenDepot() then
		return "retry"
	end

	CaveBot.PingDelay(2)

	destination = destination or getContainerByName("Depot chest")
	if not destination then return "retry" end

	for _, container in pairs(getContainers()) do
		local name = container:getName():lower()
		if not name:find("depot") and not name:find("your inbox") then
			for _, item in pairs(container:getItems()) do
				local id = item:getId()
				if table.find(lootTable, id) then
					local index = getStashingIndex(id) or item:isStackable() and 1 or 0
					statusMessage("[Depositer] stashing item: " ..id.. " to depot: "..index+1)
					CaveBot.StashItem(item, index, destination)
					return "retry"
				end
			end
		end
	end

	resetCache()
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
			value = "no",
			title = title,
			description = "Deposit items, reopen containers?",
			validation = "(yes|no)"
		}
	)
end
