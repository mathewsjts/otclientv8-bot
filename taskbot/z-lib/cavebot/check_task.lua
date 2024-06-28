CaveBot.Extensions.CheckTask = {}

CaveBot.Extensions.CheckTask.setup = function()
	CaveBot.registerAction("CheckTask", "#ffffff", function(value)
		local dataList = string.split(value, ",")
		local labelName = dataList[1]:trim()

		local tasksList = {}

		for index, task in ipairs(dataList) do
			if index > 1 then
				table.insert(tasksList, task:trim())
			end
		end

		for _, taskName in ipairs(tasksList) do
			if not TaskBot.isTaskCompleted(taskName) then
				if labelName ~= '_' then
					CaveBot.gotoLabel(labelName)
				end
				return false
			end
		end

		CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
		TaskBot.loadConfig("-TaskBotManager")
		return true
	end)

	CaveBot.Editor.registerAction("checktask", "check task", {
		value="monster",
		title="Check Task",
		description="Task names to check separated by comma",
		multiline=false
	})
end
