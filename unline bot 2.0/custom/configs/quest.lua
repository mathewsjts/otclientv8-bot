local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text
local questsFile = "/bot/" .. configName .. "/vBot_configs/".. player:getName() .."/Quests.json"

QuestConfig = MainConfig.loadConfigFile(questsFile) or {quests = {}}

QuestTracker = {}

QuestTracker.reload = function()
  QuestConfig = { quests = {} }
  MainConfig.saveConfigFile(questsFile, QuestConfig)
end

QuestTracker.setQuestValue = function(questName, questValue)
  QuestConfig["quests"][questName] = questValue
  MainConfig.saveConfigFile(questsFile, QuestConfig)
end

QuestTracker.isCompleted = function(questName, missionName)
  if not missionName then
    return QuestConfig["quests"][questName].completed
  end
  return QuestConfig["quests"][questName].missions[missionName].completed
end

local originalFunctions = {
  onQuestLog = g_game.onQuestLog,
  onQuestLine = g_game.onQuestLine,
  onTextMessage = g_game.onTextMessage,
}

function onQuestLog(quests)
  for _, quest in pairs(quests) do
    local questId = quest[1]
    local questName = string.gsub(quest[2], "%(completed%)", ""):trim()
    local isCompleted = string.find(quest[2], "%(completed%)") ~= nil
    if not QuestConfig["quests"][questName] then
      QuestTracker.setQuestValue(questName, {
        id = questId,
        completed = isCompleted,
        missions = {},
      })
    end
    g_game.requestQuestLine(questId)
  end
  return originalFunctions.onQuestLog(quests)
end

function onQuestLine(questId, questMissions)
  local questName, questSelected, questMissionsTable = nil, nil, {}
  for name, quest in pairs(QuestConfig["quests"]) do
    if quest.id == questId then
      questName, questSelected = name, quest
      break
    end
  end
  if questName then
    for _, questMission in pairs(questMissions) do
      local missionName = string.gsub(questMission[1], "%(completed%)", ""):trim()
      local isCompleted = string.find(questMission[1], "%(completed%)") ~= nil
      questMissionsTable[missionName] = {
        completed = isCompleted,
        description = questMission[2],
      }
    end
    QuestTracker.setQuestValue(questName, {
      id = questSelected.id,
      completed = questSelected.completed,
      missions = questMissionsTable,
    })
  end
  return originalFunctions.onQuestLine(questId, questMissions)
end

function onTextMessage(mode, text)
  if text:find("Your questlog has been updated.") then
    g_game.requestQuestLog()
  end
  return originalFunctions.onTextMessage(mode, text)
end

QuestTracker.reload()
g_game.onQuestLog = onQuestLog
g_game.onQuestLine = onQuestLine
g_game.onTextMessage = onTextMessage
g_game.requestQuestLog()
