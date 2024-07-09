TaskBot.loaded = false
TaskBot.taskCurrent = nil
TaskBot.tasksInProgress = {}
TaskBot.tasksCompleted = {}

if not TaskBot.loaded and StorageConfig.tasks then
	for taskName, task in pairs(StorageConfig.tasks) do
		if task.hunted >= task.total then
			table.insert(TaskBot.tasksCompleted, taskName)
		else
			table.insert(TaskBot.tasksInProgress, taskName)
		end
	end
	TaskBot.loaded = true
end

if CaveBot ~= nil and TargetBot ~= nil then
	TargetBot.setCurrentProfile("-TaskBotManager")
	CaveBot.setCurrentProfile("-TaskBotManager")
end
