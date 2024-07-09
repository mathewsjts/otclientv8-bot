CaveBot.Extensions.CheckHunt = {}

CaveBot.Extensions.CheckHunt.setup = function()
	CaveBot.registerAction("CheckHunt", "#ffffff", function(value)
		local data = string.split(value, ",")

		for _, taskName in ipairs(data) do
			if not TaskBot.isTaskCompleted(taskName) then
				CaveBot.gotoLabel("starthunt")
				return false
			end
		end

		CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
		return true
	end)

	CaveBot.Editor.registerAction("checkhunt", "check hunt", {
		value="monster",
		title="Check Hunt",
		description="Task names to check separated by comma",
		multiline=false
	})
end
