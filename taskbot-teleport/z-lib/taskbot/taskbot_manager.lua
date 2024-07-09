local botConfigName = modules.game_bot.contentsPanel.config:getCurrentOption().text

TaskBot.hasQuestStarted = function()
	if StorageConfig["quests"]["Killing in the Name of..."] then
		return true
	end
	return  false
end

TaskBot.isTaskCompleted = function(task)
	local normalized = task:gsub(" ", "")
	if table.find(TaskBot.tasksCompleted, normalized) then
		return true
	end
	return false
end

TaskBot.getNextTasks = function()
	local tasksToRequest = {}
	if table_length(TaskBot.tasksInProgress) < 3 then
		local playerTasks = StorageConfig["tasks"]
		local playerLevel = player:getLevel()
		local numberOfTasksToRequest = 3 - table_length(TaskBot.tasksInProgress)
		for index, value in pairs(TaskBot.taskList) do
			local task = value:gsub(" ", "")
			local isCompleted = TaskBot.isTaskCompleted(task)
			local alreadyInProgress = table.find(TaskBot.tasksInProgress, task)
			local hasLevel = (
				TaskBot.taskRequirements[task].maxLevel >= playerLevel and
				TaskBot.taskRequirements[task].minLevel <= playerLevel
			)
			if hasLevel and numberOfTasksToRequest > 0 and not isCompleted and not alreadyInProgress then
				table.insert(tasksToRequest, value)
				numberOfTasksToRequest = numberOfTasksToRequest - 1
			end
		end
	end
	return tasksToRequest
end

TaskBot.getCurrentTask = function()
	if #TaskBot.tasksInProgress > 0 then
		for index, value in pairs(TaskBot.taskList) do
			local task = value:gsub(" ", "")
			if table.find(TaskBot.tasksInProgress, task) then
				if not TaskBot.isTaskCompleted(task) then
					TaskBot.taskCurrent = task
					break
				end
			end
		end
	end
end

TaskBot.getCurrentTask()

TaskBot.jumpCurrentTask = function()
	local currentTaskFounded = false
	if type(TaskBot.taskCurrent) == "string" then
		for index, value in pairs(TaskBot.taskList) do
			local task = value:gsub(" ", "")
			if currentTaskFounded and table.find(TaskBot.tasksInProgress, task) then
				if not TaskBot.isTaskCompleted(task) and TaskBot.taskCurrent ~= task then
					TaskBot.taskCurrent = task
					break
				end
			end
			if task == TaskBot.taskCurrent then
				currentTaskFounded = true
			end
		end
	else
		TaskBot.getCurrentTask()
	end
end

TaskBot.loadConfig = function(name, label)
	if not name then return false end
	local configName = name:gsub(" ", "")
	CaveBot.setOff()
	TargetBot.setCurrentProfile(configName)
	CaveBot.setCurrentProfile(configName)
	CaveBot.setOff()
	schedule(1000, function()
		if label and type(label) == "string" then
			CaveBot.gotoLabel(label)
		end
		CaveBot.setOn()
	end)
end

local function botReconnect()
	local slot = #g_game["onGameStart"] + 1
	g_game["onGameStart"][slot] = function()
		g_game["onGameStart"][slot] = nil
		modules.game_bot.refresh()

		local botWindow = rootWidget:recursiveGetChildById("botWindow")
		local botConfig = botWindow:recursiveGetChildById("config")
		local botButton = botWindow:recursiveGetChildById("enableButton")

		if botConfig:isOption(botConfigName) then
			botConfig:setOption(botConfigName, false)
			if botButton:getText() == "Off" then
				botButton.onClick()
			end
		end
	end
end

local charactersWindow = rootWidget:recursiveGetChildById("charactersWindow")
local autoReconnectButton = charactersWindow:getChildById('autoReconnect')
local characterList = charactersWindow:getChildById("characters")

TaskBot.setAutoReconnectOn = function()
	if not autoReconnectButton:isOn() then
		autoReconnectButton.onClick()
	end
end

TaskBot.setAutoReconnectOff = function()
	if autoReconnectButton:isOn() then
		autoReconnectButton.onClick()
	end
end

TaskBot.hasUnsetedCharacter = function()
	local children = characterList:getChildren()
	for _, character in pairs(children) do
		local characterName = character.characterName
		local characterStorageFile = "/bot/" .. botConfigName .. "/vBot_configs/Storage/".. characterName ..".json"
		local validCharacter = string.find(characterName, "-")
		if validCharacter and not g_resources.fileExists(characterStorageFile) then
			return true
		end
	end
	return false
end

TaskBot.selectUnsetedCharacter = function()
	local children = characterList:getChildren()
	for i, character in pairs(children) do
		local characterName = character.characterName
		local characterStorageFile = "/bot/" .. botConfigName .. "/vBot_configs/Storage/".. characterName ..".json"
		local validCharacter = string.find(characterName, "-")
		if validCharacter and not g_resources.fileExists(characterStorageFile) then
			characterList:focusChild(children[i], 1)
			TaskBot.setAutoReconnectOn()
			botReconnect()
			return true
		end
	end
	return true
end

TaskBot.joinGrizzlyQuest = function()
  if not TaskBot.hasQuestStarted() then
		local npc_name = "Grizzly Adams"
		local npc = getCreatureByName(npc_name)

		if not npc then
			print("CaveBot[TaskBot]: NPC not found.")
			return false
		end
	
		if not CaveBot.ReachNPC(npc_name) then
			return "retry"
		end

		CaveBot.Conversation("hi", "join", "yes")
		CaveBot.ConversationDelay(3)
  end

  return true
end

TaskBot.reportTask = function()
	local npc_name = "Grizzly Adams"
	local npc = getCreatureByName(npc_name)
  TaskBot.taskCurrent = nil

  if not npc then
    print("CaveBot[TaskBot]: NPC not found.")
    return false
  end

	if not CaveBot.ReachNPC(npc_name) then
		return "retry"
	end

	CaveBot.Conversation("hi", "report")
	CaveBot.ConversationDelay(2)
  return true
end

TaskBot.requestTasks = function(tasks)
	if type(tasks) == "string" then
		tasks = { tasks }
	end
	if type(tasks) == "table" and table_length(tasks) > 0 then
		local npc_name = "Grizzly Adams"
		local npc = getCreatureByName(npc_name)

		if not npc then
			print("CaveBot[TaskBot]: NPC not found.")
			return false
		end
	
		if not CaveBot.ReachNPC(npc_name) then
			return "retry"
		end

		local messages = {"hi"}
		for i, task in pairs(tasks) do
			table.insert(messages, task)
			table.insert(messages, "yes")
		end

		CaveBot.ConversationList(messages)
		CaveBot.ConversationDelay(#messages + 1)
	end

	return true
end
