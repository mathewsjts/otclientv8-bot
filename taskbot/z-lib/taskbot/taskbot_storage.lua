if not StorageConfig or not StorageConfig.quests or not StorageConfig.tasks then
	StorageConfig = {
		quests = {},
		tasks = {}
	}
	vBotConfigSave("storage")
end

StorageCfg = {}

StorageCfg.setQuest = function(name, value)
	StorageConfig["quests"][name] = value
	vBotConfigSave("storage")
end

StorageCfg.setTask = function(monster, value)
	StorageConfig["tasks"][monster] = value
	vBotConfigSave("storage")
end
