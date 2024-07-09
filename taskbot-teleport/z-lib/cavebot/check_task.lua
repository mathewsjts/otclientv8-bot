CaveBot.Extensions.CheckTask = {}

CaveBot.Extensions.CheckTask.setup = function()
	CaveBot.registerAction("CheckTask", "#ffffff", function(value)
		local data = string.split(value, ",")

		for _, taskName in ipairs(data) do
			if not TaskBot.isTaskCompleted(taskName) then
				return false
			end
		end

		CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
		TaskBot.loadConfig("-TaskBotManager", "tasker")
		return true
	end)

	CaveBot.Editor.registerAction("checktask", "check task", {
		value="monster",
		title="Check Task",
		description="Task names to check separated by comma",
		multiline=false
	})
end
