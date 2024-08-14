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

-- function onQuestLog(quests)
--   for _, quest in pairs(quests) do
--     local questId = quest[1]
--     local questName = string.gsub(quest[2], "%(completed%)", ""):trim()
--     local isCompleted = string.find(quest[2], "%(completed%)") ~= nil
--     if not QuestConfig["quests"][questName] then
--       QuestTracker.setQuestValue(questName, {
--         id = questId,
--         completed = isCompleted,
--         missions = {},
--       })
--     end
--     g_game.requestQuestLine(questId)
--   end
-- end

-- function onQuestLine(questId, questMissions)
--   local questName, questSelected, questMissionsTable = nil, nil, {}
--   for name, quest in pairs(QuestConfig["quests"]) do
--     if quest.id == questId then
--       questName, questSelected = name, quest
--       break
--     end
--   end
--   if questName then
--     for _, questMission in pairs(questMissions) do
--       local missionName = string.gsub(questMission[1], "%(completed%)", ""):trim()
--       local isCompleted = string.find(questMission[1], "%(completed%)") ~= nil
--       questMissionsTable[missionName] = {
--         completed = isCompleted,
--         description = questMission[2],
--       }
--     end
--     QuestTracker.setQuestValue(questName, {
--       id = questSelected.id,
--       completed = questSelected.completed,
--       missions = questMissionsTable,
--     })
--   end
-- end

-- onTextMessage(function(mode, text)
--   if string.find(text:lower(), "your questlog has been updated") then
--     g_game.requestQuestLog()
--   end
-- end)

-- QuestTracker.reload()
-- g_game.onQuestLog = onQuestLog
-- g_game.onQuestLine = onQuestLine
-- g_game.requestQuestLog()

questLogButton = nil
questLineWindow = nil

questLogButtonClicked = false
questLineClicked = false
questLineClickedId = nil

rootWidget = g_ui.getRootWidget()

questLogButton = rootWidget:recursiveGetChildById("questLogButton")
local window = rootWidget:recursiveGetChildById("questLogWindow")

if questLogButton then
  questLogButton.onMouseRelease = function(widget, mousePos, mouseButton)
    if widget:containsPoint(mousePos) and mouseButton ~= MouseMidButton and mouseButton ~= MouseTouch then
      questLogButtonClicked = true
      g_game.requestQuestLog()
      return true
    end
  end
end

function show(questlog)
  if questlog then
    window:raise()
    window:show()
    window:focus()
    window.missionlog.currentQuest = nil
    window.questlog:setVisible(true)
    window.missionlog:setVisible(false)
    window.closeButton:setText('Close')
    window.showButton:setVisible(true)
    window.missionlog.track:setEnabled(false)
    window.missionlog.track:setChecked(false)
    window.missionlog.missionDescription:setText('')
  else
    window.questlog:setVisible(false)
    window.missionlog:setVisible(true)
    window.closeButton:setText('Back')
    window.showButton:setVisible(false)
  end
end

function showQuestLine()
  local questList = window.questlog.questList
  local child = questList:getFocusedChild()
  g_game.requestQuestLine(child.questId)
  window.missionlog.questName:setText(child.questName)
  window.missionlog.currentQuest = child.questId
end

function openQuestLogWindow(quests)
  show(true)
  local questList = window.questlog.questList
  questList:destroyChildren()
  for i, questEntry in pairs(quests) do
    local id = questEntry[1]
    local name = questEntry[2]
    local completed = questEntry[3]
    local questLabel = g_ui.createWidget('QuestLabel', questList)
    questLabel:setChecked(i % 2 == 0)
    questLabel.questId = id
    questLabel.questName = name
    name = completed and name.." (completed)" or name
    questLabel:setText(name)
    questLabel.onDoubleClick = function()
      window.missionlog.currentQuest = id
      questLineClicked = true
      questLineClickedId = id
      g_game.requestQuestLine(id)
      window.missionlog.questName:setText(questLabel.questName)
    end
  end
  questList:focusChild(questList:getFirstChild())
end

function openQuestLineWindow(questId, questMissions)
  show(false)
  local missionList = window.missionlog.missionList
  if questId == window.missionlog.currentQuest then
    missionList:destroyChildren()
  end
  for i,questMission in pairs(questMissions) do
    local name = questMission[1]
    local description = questMission[2]
    local missionLabel = g_ui.createWidget('QuestLabel', missionList)
    local widgetId = questId..'.'..i
    missionLabel:setChecked(i % 2 == 0)
    missionLabel:setId(widgetId)
    missionLabel.questId = questId
    missionLabel.trackData = widgetId
    missionLabel:setText(name)
    missionLabel.description = description
    missionLabel:setVisible(questId == window.missionlog.currentQuest)
  end
  local focusTarget = missionList:getFirstChild()
  if focusTarget and focusTarget:isVisible() then
    missionList:focusChild(focusTarget)
  end
end

function questLogTracker(quests)
  if questLogButtonClicked then
    questLogButtonClicked = false
    openQuestLogWindow(quests)
  end
  for i = 1, #quests, 1 do
    local questId = quests[i][1]
    local questName = quests[i][2]
    local isCompleted = quests[i][3]
    if not QuestConfig["quests"] then
      return
    end
    if not QuestConfig["quests"][questName] then
      QuestTracker.setQuestValue(questName, {
        id = questId,
        completed = isCompleted,
        missions = {},
      })
    end
  end
end

function questLineTracker(questId, questMissions)
	if questLineClicked and questLineClickedId == questId then
		questLineClicked = false
		questLineClickedId = nil
		openQuestLineWindow(questId, questMissions)
	end
  local quest_name
  local quest_selected
  local quest_missions = {}

  if not QuestConfig["quests"] then
    return
  end

  for name, quest in pairs(QuestConfig["quests"]) do
    if quest.id == questId then
      quest_name = name
      quest_selected = quest
    end
  end

  for i = 1, #questMissions, 1 do
    quest_missions[questMissions[i][1]] = questMissions[i][2]
  end


  QuestTracker.setQuestValue(quest_name, {
    id = quest_selected.id,
    completed = quest_selected.completed,
    missions = quest_missions
  })
end

g_game["onQuestLog"] = questLogTracker
g_game["onQuestLine"] = questLineTracker

function destroyWindows()
  if questLogWindow then
    questLogWindow:destroy()
  end
  if questLineWindow then
    questLineWindow:destroy()
  end
end

g_game.requestQuestLog()
questsTracker = macro(2000, function()
  g_game.requestQuestLog()
  if not QuestConfig or not QuestConfig["quests"] then
    QuestConfig = {
      quests = {}
    }
    MainConfig.saveConfigFile(questsFile, QuestConfig)
    return
  end
  for _, quest in pairs(QuestConfig["quests"]) do
    g_game.requestQuestLine(quest.id)
  end
end)