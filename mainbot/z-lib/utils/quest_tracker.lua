questLogButton = nil
questLineWindow = nil

questLogButtonClicked = false
questLineClicked = false
questLineClickedId = nil

QuestTracker = {}

QuestTracker.reload = function()
  QuestsConfig = {quests = {}}
  vBotConfigSave("quests")
end

QuestTracker.setQuestValue = function(questName, questValue)
  QuestsConfig["quests"][questName] = questValue
  vBotConfigSave("quests")
end

QuestTracker.isInitialized = function(questName)
  local isInitialized = false
  for questNameConfig, _ in pairs(QuestsConfig["quests"]) do
    local isSameQuestName = questNameConfig == questName
    local isSameQuestNameCompleted = questNameConfig == questName .. " (completed)"
    if isSameQuestName or isSameQuestNameCompleted then
      isInitialized = true
      break
    end
  end
  return isInitialized
end

QuestTracker.isCompleted = function(questName, missionName)
  local isCompleted = false
  for questNameConfig, questConfig in pairs(QuestsConfig["quests"]) do
    if questNameConfig == questName.." (completed)" then
      isCompleted = true
      break
    end
    if questNameConfig == questName and missionName ~= nil then
      for missionNameConfig, missionDescriptionConfig in pairs(questConfig.missions) do
        if missionNameConfig == missionName .. " (completed)" then
          isCompleted = true
          break
        end
      end
    end
  end
  return isCompleted
end

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
    local qid = quests[i][1]
    local name = quests[i][2]
    local isCompleted = quests[i][3]
    if not QuestsConfig["quests"] then
      return
    end
    if not QuestsConfig["quests"][name] then
      QuestTracker.setQuestValue(name, {
        id = qid,
        completed = isCompleted,
        missions = {}
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

  if not QuestsConfig["quests"] then
    return
  end

  for name, quest in pairs(QuestsConfig["quests"]) do
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

QuestTracker.reload()
g_game["onQuestLog"] = questLogTracker
g_game["onQuestLine"] = questLineTracker
questsTracker = macro(2000, function()
  g_game.requestQuestLog()
  for _, quest in pairs(QuestsConfig["quests"]) do
    g_game.requestQuestLine(quest.id)
  end
end)
