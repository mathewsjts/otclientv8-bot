local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text

dofile("/custom/followbot/communicationSystem.lua")
dofile("/custom/followbot/walkingSystem.lua")
dofile("/custom/followbot/interactingSystem.lua")
dofile("/custom/followbot/battleSystem.lua")
g_ui.importStyle("/bot/" .. configName .. "/custom/followbot/interface.otui")

local enableToLog = false
local followbotMacro = nil
local retries = 0
local leaderName = storage.followingTarget or "Player"
local actions = {
  {
    ["type"] = "init",
    ["finished"] = false,
  }
}
local history = {}

CommunicationSystem.leaderUpdatesListener = function(action)
  info("Added a new action of type: " .. action.type)

  table.insert(actions, action)
end

local function onConcludeAction()
  -- info("Action concluded")
  -- info("Actions before: " .. #actions)
  retries = 0
  local action = actions[1]
  if action and not action.isHistory then
    action.isHistory = true
    table.insert(history, action)
    actions[1].finished = true
  end
  -- info("Actions after: " .. #actions)
end

local function onFail()
  -- info("Fails: " .. retries)
  retries = retries + 1
end

WalkingSystem.onConcludeAction = onConcludeAction
WalkingSystem.onFail = onFail

InteractingSystem.onConcludeAction = onConcludeAction
InteractingSystem.onFail = onFail

BattleSystem.onConcludeAction = onConcludeAction
BattleSystem.onFail = onFail



local function nextAction()
  local action = nil
  if retries > 5 and #history > 0 then
    action = history[#history]

    if action then
      table.remove(history, #history)
      action.finished = false
      action.isHistory = false
      local newActions = {}

      table.insert(newActions, action)

      for _, act in ipairs(actions) do
        table.insert(newActions, act)
      end

      actions = newActions
      retries = 0

      info("Executing history")
    end
  elseif actions[1] then
    action = actions[1]

    if action.finished then
      table.remove(actions, 1)
      return nextAction()
    end
  end

  return action
end

local function init(action)
  info("Initialized.")
  action.finished = true
end

local function handleWalking(action)
  local dest = action.dest

  if dest then
    -- info("Walking to: " .. dest.x .. ", " .. dest.y .. ", " .. dest.z)
    WalkingSystem.run(dest)
  end
end

local walkingHandler = {}
walkingHandler.run = function(action)
  local dest = action.dest

  if dest then
    -- info("Walking to: " .. dest.x .. ", " .. dest.y .. ", " .. dest.z)
    WalkingSystem.run(dest)
  end
end

walkingHandler.stop = function()
  WalkingSystem.stop()
end

local useItemHandler = {}
useItemHandler.run = function(action)
  local itemId = action.itemId

  if itemId then
    InteractingSystem.use(itemId)
  end
end

useItemHandler.stop = function()
end

local groundUseHandler = {}
groundUseHandler.run = function(action)
  local itemId = action.itemId
  local position = action.position

  if itemId then
    InteractingSystem.groundUse(itemId, position)
  end
end

groundUseHandler.stop = function()
end

local groundUseWithHandler = {}
groundUseWithHandler.run = function(action)
  local itemId = action.itemId
  local position = action.position

  if itemId then
    InteractingSystem.groundUseWith(itemId, position)
  end
end

groundUseWithHandler.stop = function()
end

local attackPlayerHandler = {}
attackPlayerHandler.run = function(action)
  local creatureId = action.creatureId

  if creatureId then
    BattleSystem.attack(creatureId)
  end
end

attackPlayerHandler.stop = function()
end

local attackMonsterHandler = {}
attackMonsterHandler.run = function(action)
  local creatureId = action.creatureId
  info("Target creature: " .. creatureId)

  if creatureId then
    BattleSystem.attack(creatureId)
  end
end

attackMonsterHandler.stop = function()
end

local stopAttackHandler = {}
stopAttackHandler.run = function(action)
  BattleSystem.stopAttack()
end

stopAttackHandler.stop = function()
end

local actionCommands = {
  -- ["init"] = init,
  ["walk"]      = walkingHandler,
  ["useItem"]   = useItemHandler,
  ["groundUse"] = groundUseHandler,
  ["groundUseWith"] = groundUseWithHandler,
  ["attackPlayer"] = attackPlayerHandler,
  ["attackMonster"] = attackMonsterHandler,
  ["stopAttack"] = stopAttackHandler,
}

local function canFollow(creature)
  local creaturePosition = creature:getPosition()

  local isCloser = posz() == creaturePosition.z and math.abs(posx() - creaturePosition.x) < 2 and math.abs(posy() - creaturePosition.y) < 2
  local path = getPath(player:getPosition(), creaturePosition, 20, { ignoreNonPathable = true, allowUnseen = true, allowOnlyVisibleTiles = false, precision = 1 }) or {}

  return isCloser or #path > 0
end

local function inGameFollow(creature)
  if g_game.isFollowing() then
    actions = {}
    history = {}
  end
  if creature then
    if not g_game.isFollowing() then
      g_game.follow(creature)
      actions = {}
    elseif g_game.isFollowing() and getDistanceBetween(pos(), creature:getPosition()) > 1 then
      actions = {}
      g_game.cancelFollow()
      inGameFollow(creature)
    end
  end
end

-- local old = now
-- onPlayerPositionChange(function()
--   local current = now
--   info("Elapsed: " .. current - old)
--   old = current
-- end)

setDefaultTab("Main")
local ui = UI.createWidget('SwitchAndTextEditPanel')

followbotMacro = macro(50, function()
  if not ui.followSwitch:isOn() then
    g_game.cancelFollow()
    actions = {}
    history = {}
    followbotMacro.setOff()
    return
  end

  local attackingCreature = g_game.getAttackingCreature()
  local creature = getCreatureByName(ui.followingTarget:getText())
  local currentAction = nextAction()

  if
        currentAction
    and (currentAction.type == "attackMonster"
    or  currentAction.type == "attackPlayer"
    or  currentAction.type == "stopAttack")
  then
    local command = actionCommands[currentAction.type]

    if command then command.run(currentAction) end
  end

  if attackingCreature then
    for _, handler in pairs(actionCommands) do
      handler.stop()
    end
  elseif creature and canFollow(creature) then
    for _, handler in pairs(actionCommands) do
      handler.stop()
    end

    if enableToLog then
      info("Ingame Follow")
    end

    inGameFollow(creature)
  else
    local currentAction = nextAction()

    if enableToLog then
      info("Followbot")
    end

    if currentAction then
      local command = actionCommands[currentAction.type]

      if command then command.run(currentAction) end
    end
  end
end)

local setMacroDelay = function(time)
  -- info("setting delay: " .. time)
  followbotMacro.delay = math.max(followbotMacro.delay or 0, now + time)
end

local setMacroOn  = followbotMacro.setOn
local setMacroOff = followbotMacro.setOff

followbotMacro.setOn = function()
  leaderName = ui.followingTarget:getText()
  CommunicationSystem.listen(ui.followingTarget:getText())
  setMacroOn()
end

followbotMacro.setOff = function()
  setMacroOff()
end

followbotMacro.restart = function()
  followbotMacro.setOff()
  followbotMacro.setOn()
end

WalkingSystem.setDelay = setMacroDelay
InteractingSystem.setDelay = setMacroDelay


ui.followingTarget:setText(leaderName)

ui.followSwitch.onClick = function(widget)

  if widget:isOn() then
    widget:setOn(false)
  else
    widget:setOn(true)
    followbotMacro.setOn()
  end
end

ui.followingTarget.onTextChange = function()
  leaderName = ui.followingTarget:getText()
  storage.followingTarget = ui.followingTarget:getText()
  followbotMacro.restart()
end

-- Log followbot status
hotkey('Shift+d', function()
  local firstAction = actions[1] or {}
  local dest = firstAction.dest or {}
  local actionsDest = "x: " .. tostring(dest.x) .. ", y: " .. tostring(dest.y) .. ", z: " .. tostring(dest.z)
  info(
    "ActionsQueue: "  .. #actions .. "\n" ..
    "ActionType: "  .. tostring(firstAction.type) .. "\n" ..
    "ActionDest: "  .. actionsDest .. "\n" ..
    "Delay: "  .. math.max(followbotMacro.delay - now, 0) .. "\n"
  )
end)

hotkey('Shift+i', function()
  enableToLog = not enableToLog
end)
