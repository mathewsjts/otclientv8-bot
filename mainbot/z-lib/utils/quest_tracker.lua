local questLogButtonClicked = false
local questLineClicked = false
local questLineClickedId = nil

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
  for questNameConfig, _ in pairs(QuestsConfig["quests"]) do
    if questNameConfig == questName or questNameConfig == questName .. " (completed)" then
      return true
    end
  end
  return false
end

QuestTracker.isCompleted = function(questName, missionName)
  for questNameConfig, questConfig in pairs(QuestsConfig["quests"]) do
    if questNameConfig == questName .. " (completed)" then
      return true
    end
    if questNameConfig == questName and missionName then
      for missionNameConfig, _ in pairs(questConfig.missions) do
        if missionNameConfig == missionName .. " (completed)" then
          return true
        end
      end
    end
  end
  return false
end

local rootWidget = g_ui.getRootWidget()
local questLogButton = rootWidget:recursiveGetChildById("questLogButton")
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

local function show(questlog)
  window:raise()
  window:show()
  window:focus()
  window.missionlog.currentQuest = nil
  window.questlog:setVisible(questlog)
  window.missionlog:setVisible(not questlog)
  window.closeButton:setText(questlog and 'Close' or 'Back')
  window.showButton:setVisible(questlog)
  window.missionlog.track:setEnabled(false)
  window.missionlog.track:setChecked(false)
  window.missionlog.missionDescription:setText('')
end

local function openQuestLogWindow(quests)
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

local function openQuestLineWindow(questId, questMissions)
  show(false)
  local missionList = window.missionlog.missionList
  missionList:destroyChildren()
  for i, questMission in pairs(questMissions) do
    local name = questMission[1]
    local description = questMission[2]
    local missionLabel = g_ui.createWidget('QuestLabel', missionList)
    local widgetId = questId .. '.' .. i
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

local function questLogTracker(quests)
  if questLogButtonClicked then
    questLogButtonClicked = false
    openQuestLogWindow(quests)
  end
  for _, quest in pairs(quests) do
    local qid = quest[1]
    local name = quest[2]
    local isCompleted = quest[3]
    if not QuestsConfig["quests"][name] then
      QuestTracker.setQuestValue(name, { id = qid, completed = isCompleted, missions = {} })
    end
  end
end

local function questLineTracker(questId, questMissions)
  if questLineClicked and questLineClickedId == questId then
    questLineClicked = false
    questLineClickedId = nil
    openQuestLineWindow(questId, questMissions)
  end
  local questName, questSelected, questMissionsTable = nil, nil, {}
  for name, quest in pairs(QuestsConfig["quests"]) do
    if quest.id == questId then
      questName, questSelected = name, quest
      break
    end
  end
  for _, questMission in pairs(questMissions) do
    questMissionsTable[questMission[1]] = questMission[2]
  end
  if questSelected then
    QuestTracker.setQuestValue(questName, { id = questSelected.id, completed = questSelected.completed, missions = questMissionsTable })
  end
end

QuestTracker.reload()
g_game.onQuestLog = questLogTracker
g_game.onQuestLine = questLineTracker
questsTracker = macro(2000, function()
  g_game.requestQuestLog()
  for _, quest in pairs(QuestsConfig["quests"]) do
    g_game.requestQuestLine(quest.id)
  end
end)
