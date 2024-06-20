questLogButton = nil
questLineWindow = nil

questLogButtonClicked = false
questLineClicked = false
questLineClickedId = nil

rootWidget = g_ui.getRootWidget()

questLogButton = rootWidget:recursiveGetChildById("questLogButton")

if questLogButton then
  questLogButton.onMouseRelease = function(widget, mousePos, mouseButton)
    if widget:containsPoint(mousePos) and mouseButton ~= MouseMidButton and mouseButton ~= MouseTouch then
      questLogButtonClicked = true
      g_game.requestQuestLog()
      return true
    end
  end
end

function openQuestLogWindow(quests)
  destroyWindows()

  questLogWindow = g_ui.createWidget('QuestLogWindow', rootWidget)
  local questList = questLogWindow:getChildById('questList')

  for i = 1, #quests, 1 do
    local id = quests[i][1]
    local name = quests[i][2]
    local completed = quests[i][3]

    local questLabel = g_ui.createWidget('QuestLabel', questList)
    questLabel:setOn(completed)
    questLabel:setText(name)
    questLabel.onDoubleClick = function()
      questLogWindow:hide()
      questLineClicked = true
      questLineClickedId = id
      g_game.requestQuestLine(id)
    end
  end

  questLogWindow.onDestroy = function()
    questLogWindow = nil
  end

  questList:focusChild(questList:getFirstChild())
end

function openQuestLineWindow(questId, questMissions)
  if questLogWindow then questLogWindow:hide() end
  if questLineWindow then questLineWindow:destroy() end

  questLineWindow = g_ui.createWidget('QuestLineWindow', rootWidget)
  local missionList = questLineWindow:getChildById('missionList')
  local missionDescription = questLineWindow:getChildById('missionDescription')

  modules.corelib.connect(missionList, { onChildFocusChange = function(self, focusedChild)
    if focusedChild == nil then return end
    missionDescription:setText(focusedChild.description)
  end })

  for i = 1, #questMissions, 1 do
    local name = questMissions[i][1]
    local description = questMissions[i][2]

    local missionLabel = g_ui.createWidget('MissionLabel')
    missionLabel:setText(name)
    missionLabel.description = description
    missionList:addChild(missionLabel)
  end

  questLineWindow.onDestroy = function()
    if questLogWindow then questLogWindow:show() end
    questLineWindow = nil
  end

  missionList:focusChild(missionList:getFirstChild())
end

if not storage["playerStatus"] then
  storage["playerStatus"] = {}
end

if not storage["playerStatus"][player:getName()] then
  storage["playerStatus"][player:getName()] = {
    quests = {},
    tasks = {}
  }
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

    storage["playerStatus"][player:getName()]["quests"][name] = {
      id = qid,
      completed = isCompleted
    }
  end
end

function questLineTracker(questId, questMissions)
  if questLineClicked and questLineClickedId == questId then
    questLineClicked = false
    questLineClickedId = nil
    openQuestLineWindow(questId, questMissions)
  end


  if  storage["playerStatus"][player:getName()]["quests"]["Killing in the Name of..."] and
  questId == storage["playerStatus"][player:getName()]["quests"]["Killing in the Name of..."]["id"] then
    -- TaskBot.tasksInProgress = {}

    for i = 1, #questMissions, 1 do
      local name = questMissions[i][1]
      local description = questMissions[i][2]

      if string.find(description, "You already hunted") then
        local monster = string.split( string.split( name, ":")[2], "(" )[1]:trim():gsub(" ", "")
        local progress = description:gsub("[^0-9/]", ""):trim()
        local monstersHunted = tonumber(string.split(progress, "/")[1])
        local monstersToHunt = tonumber(string.split(progress, "/")[2])

        if monstersHunted < monstersToHunt then
          if not table.find(TaskBot.tasksInProgress, monster) then
            table.insert(TaskBot.tasksInProgress, monster)
          end
        else
          if not table.find(TaskBot.tasksCompleted, monster) then
            table.insert(TaskBot.tasksCompleted, monster)
            table.removevalue(TaskBot.tasksInProgress, monster)
          end
        end

        -- if monstersHunted < monstersToHunt then
        --   table.insert(TaskBot.tasksInProgress, monster)
        -- else
        --   table.insert(TaskBot.tasksCompleted, monster)
        -- end

        storage["playerStatus"][player:getName()]["tasks"][monster] = {
          hunted = monstersHunted,
          total = monstersToHunt
        }
      end
    end
  end
end

g_game["onQuestLog"] = questLogTracker
g_game["onQuestLine"] = questLineTracker

-- local text = "test"
-- local messageLabel = rootWidget:recursiveGetChildById("middleCenterLabel")
-- -- messageLabel = modules.game_textmessage:recursiveGetChildById("middleCenterLabel")
-- messageLabel:setText(text)
-- messageLabel:setColor('#ffffff')
-- messageLabel:setVisible(true)
-- -- messageLabel.hideEvent:cancel()
-- messageLabel.hideEvent = schedule(math.max(#text * 50, 3000), function() messageLabel:setVisible(false) end)

-- LOOT TRACKER
onTalk(function(name, level, mode, text, channelId, pos)
  local lootChannel = getChannelId("loot channel")
  if (channelId == lootChannel) then
    local messageLabel = rootWidget:recursiveGetChildById("middleCenterLabel")

    messageLabel:setText(text)
    messageLabel:setColor('#ffffff')
    messageLabel:setVisible(true)
    messageLabel.hideEvent = schedule(math.max(#text * 50, 3000), function() messageLabel:setVisible(false) end)
  end
  -- if (text:find("Loot")) then
  --   -- say("utana vid")
  --   say("Mode: " .. tostring(mode) .. "; id: " .. tostring(channelId))
  --   -- delay("500")
  -- end
end)

-- local childs = rootWidget:getChildCount()
-- local waitTime = 1500

-- for i = 1, childs, 1 do
--   local child = rootWidget:getChildByIndex(i)
--   if child:getText() then
--     say(i)
--   end
-- end


-- say(tostring(rootWidget:recursiveGetChildById("middleCenterLabel")))
-- modules.game_textmessage.displayBroadcastMessage("hi")

function destroyWindows()
  if questLogWindow then
    questLogWindow:destroy()
  end

  if questLineWindow then
    questLineWindow:destroy()
  end
end

tasksTracker = macro(2000, function()
  g_game.requestQuestLog()

  if storage["playerStatus"][player:getName()]["quests"]["Killing in the Name of..."] then
    local id = storage["playerStatus"][player:getName()]["quests"]["Killing in the Name of..."]["id"]
    g_game.requestQuestLine(id)
  end
end)

