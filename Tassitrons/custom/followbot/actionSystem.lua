local isRunning = false
local actions = {}
local observers = {}
local interactions = {}
local groundInteractions = {}
local isGroundUsing = false
local groundUsingTarget = nil
local groundUsingTargetDist = 1000
local fails = 0
local usedTiles = {}
local usedOnTiles = {}

ActionSystem = {}
ActionSystem.ON_POSITION_CHANGE = "ON_POSITION_CHANGE"
ActionSystem.ON_PLAYER_POSITION_CHANGE = "ON_POSITION_CHANGE"
ActionSystem.ON_WALK = "ON_WALK"
ActionSystem.ON_TELEPORT = "ON_TELEPORT"
ActionSystem.ON_INVENTORY_USE = "ON_INVENTORY_USE"
ActionSystem.ON_GROUND_USE = "ON_GROUND_USE"
ActionSystem.ON_INVENTORY_USE_WITH = "ON_INVENTORY_USE_WITH"
ActionSystem.ON_GROUND_USE_WITH = "ON_GROUND_USE_WITH"
ActionSystem.ON_ATTACK = "ON_ATTACK"
ActionSystem.ON_PLAYER_ATTACK = "ON_PLAYER_ATTACK"
ActionSystem.ON_STOP_ATTACK = "ON_STOP_ATTACK"

for _, actionName in pairs(ActionSystem) do
  table.insert(actions, actionName)
  observers[actionName] = {}
end

ActionSystem.setOn = function() isRunning = true end
ActionSystem.setOf = function() isRunning = false end

ActionSystem.registerObserverToAction = function(actionName, callback, config)
  table.insert(observers[actionName], {
    ["callback"] = callback,
    ["config"] = config,
  })
end

local function hasObserverTo(actionName)
  return observers[actionName] and #observers[actionName] > 0
end

local function hasObserverToOneOfActions(actionNames)
  for _, actionName in pairs(actionNames) do
    if hasObserverTo(actionName) then
      return true
    end
  end

  return false
end

local lastPositionSended = nil
onPlayerPositionChange(function(oldPos, newPos)
  if not oldPos or not newPos then return end

  if
    -- isRunning and
    hasObserverToOneOfActions({
      ActionSystem.ON_POSITION_CHANGE,
      ActionSystem.ON_WALK,
      ActionSystem.ON_TELEPORT,
    })
  then
    local deltaPos = math.abs(newPos.x - oldPos.x) + math.abs(newPos.y - oldPos.y)
    local deltaZ = math.abs(newPos.z - oldPos.z)
    if hasObserverTo(ActionSystem.ON_TELEPORT) and (deltaPos > 2 or deltaZ > 0) then
      -- on teleport
      -- info("POS: " .. newPos.x .. ", " .. newPos.y .. ", " .. newPos.z)
      local posToSend = newPos
      newPos.t = true
      for _, attrs in pairs(observers[ActionSystem.ON_TELEPORT]) do
        attrs.callback(posToSend)
      end

      for i=#usedTiles, 1, -1 do
        local usedThing = usedTiles[i]

        if    usedThing
          and math.abs(usedThing.position.x - newPos.x) < 2
          and math.abs(usedThing.position.y - newPos.y) < 2
          and usedThing.position.z == newPos.z
        then
          for _, attrs in pairs(observers[ActionSystem.ON_GROUND_USE]) do
            attrs.callback(usedThing)
          end

          usedTiles = {}
          break
        end
      end

      for i=#usedOnTiles, 1, -1 do
        local usedThing = usedOnTiles[i]

        if    usedThing
          and math.abs(usedThing.position.x - newPos.x) < 2
          and math.abs(usedThing.position.y - newPos.y) < 2
          and usedThing.position.z == newPos.z
        then
          info(usedThing.id)
          for _, attrs in pairs(observers[ActionSystem.ON_GROUND_USE_WITH]) do
            attrs.callback(usedThing)
          end

          usedOnTiles = {}
          break
        end
      end

      lastPositionSended = newPos
      if hasObserverTo(ActionSystem.ON_INVENTORY_USE) and #interactions > 0 then
        local actionsToSend = table.copy(interactions)
        interactions = {}
        alreadySended = true

        for _, attrs in pairs(observers[ActionSystem.ON_INVENTORY_USE]) do
          for _, action in pairs(actionsToSend) do
            attrs.callback(action)
          end
        end
      end
    elseif hasObserverTo(ActionSystem.ON_WALK) and deltaPos > 0 then
      -- on walk
      local actionsToSend = table.copy(interactions)
      interactions = {}
      alreadySended = true

      for _, attrs in pairs(observers[ActionSystem.ON_INVENTORY_USE]) do
        for _, action in pairs(actionsToSend) do
          attrs.callback(action)
        end
      end

      for i=#usedTiles, 1, -1 do
        local usedThing = usedTiles[i]

        if usedThing and not usedThing.isWalkable and oldPos.x == usedThing.position.x and oldPos.y == usedThing.position.y and oldPos.z == usedThing.position.z then
          for _, attrs in pairs(observers[ActionSystem.ON_WALK]) do
            attrs.callback(newPos)
          end

          for _, attrs in pairs(observers[ActionSystem.ON_GROUND_USE]) do
            attrs.callback(usedThing)
          end

          for _, attrs in pairs(observers[ActionSystem.ON_WALK]) do
            attrs.callback(oldPos)
          end

          usedTiles = {}
          break
        end
      end

      local canSendPosition = not lastPositionSended or (math.abs(lastPositionSended.x - newPos.x) > 7 or math.abs(lastPositionSended.y - newPos.y) > 5)
      if canSendPosition then
        for _, attrs in pairs(observers[ActionSystem.ON_WALK]) do
          attrs.callback(newPos)
        end

        lastPositionSended = newPos
      end
    end
  end
end)

local irrelevantItens = {
  [266]     = true, -- red potion
  [3725]    = true, -- brown mushroom
}

local function isIrrelevantItem(id)
  return irrelevantItens[id]
end

local isUsing = false
local usingInterval = 500
local targetDistance = 0
local targetPosition = {}

onUse(function(pos, itemId, stackPos, subType)
  isUsing = true

  if
    hasObserverToOneOfActions({
      ActionSystem.ON_INVENTORY_USE,
      ActionSystem.ON_GROUND_USE,
    })
  then
    if pos.x == 0xFFFF then
      -- inventory
      if not isIrrelevantItem(itemId) and hasObserverTo(ActionSystem.ON_INVENTORY_USE) then
        if not table.contains(interactions, itemId) then
          table.insert(interactions, itemId)
        end

        if not isUsing then
          schedule(usingInterval, function()
            if alreadySended then
              alreadySended = false
              isUsing = false
            else
              local actionsToSend = table.copy(interactions)
              interactions = {}

              for _, action in pairs(actionsToSend) do
                for _, attrs in pairs(observers[ActionSystem.ON_INVENTORY_USE]) do
                  attrs.callback(action)
                end
              end
            end
          end)
        end
      end
    else
      -- ground
      local usedTile = g_map.getTile(pos)
      local isWalkable = usedTile:isWalkable()
      if hasObserverTo(ActionSystem.ON_GROUND_USE) then

        table.insert(usedTiles, {
          ["id"] = itemId,
          ["position"] = pos,
          ["isWalkable"] = isWalkable,
        })
      end
    end
  end
end)

onUseWith(function(pos, itemId, target, subType)
  if
    hasObserverToOneOfActions({
      ActionSystem.ON_INVENTORY_USE_WITH,
      ActionSystem.ON_GROUND_USE_WITH,
    })
  then
    local targetPosition = target:getPosition()
    if targetPosition.x == 0xFFFF then
      -- inventory

    else
      -- ground
      if hasObserverTo(ActionSystem.ON_GROUND_USE_WITH) then
        table.insert(usedOnTiles, {
          ["id"] = itemId,
          ["position"] = target:getPosition()
        })
      end
    end
  end
end)

local function onSendMessage(message)
  if hasObserverTo(ActionSystem.ON_FLY) and string.starts(message, "!fly ") then
    local direction = string.split(message, " ")[2]

    if direction then
      for _, attrs in pairs(observers[ActionSystem.ON_FLY]) do
        attrs.callback(pos, message)
      end
    end
  elseif hasObserverTo(ActionSystem.ON_TELEPORT_SCROLL) and string.starts(message, "!tp ") then
    local city = string.split(message, " ")[2]

    if city then
      for _, attrs in pairs(observers[ActionSystem.ON_TELEPORT_SCROLL]) do
        attrs.callback(pos, message)
      end
    end
  elseif hasObserverTo(ActionSystem.ON_HOUSE_TELEPORT) and string.starts(message, "!house ") then
    local owner = string.split(message, " ")[2]

    if owner then
      for _, attrs in pairs(observers[ActionSystem.ON_HOUSE_TELEPORT]) do
        attrs.callback(pos, message)
      end
    end
  elseif string.starts(message, "hi") then
    -- check for NPC talk
  end
end

onAttackingCreatureChange(function(creature, oldCreature)
  if creature then
    if creature:isPlayer() and hasObserverTo(ActionSystem.ON_PLAYER_ATTACK) then
      for _, attrs in pairs(observers[ActionSystem.ON_PLAYER_ATTACK]) do
        attrs.callback(creature:getId())
      end
    elseif creature:isMonster() and hasObserverTo(ActionSystem.ON_ATTACK) then
      info("Attack creature: " .. creature:getId())
      for _, attrs in pairs(observers[ActionSystem.ON_ATTACK]) do
        attrs.callback(creature:getId())
      end
    end
  elseif hasObserverTo(ActionSystem.ON_STOP_ATTACK) then
    for _, attrs in pairs(observers[ActionSystem.ON_STOP_ATTACK]) do
      attrs.callback()
    end
  end
end)

-- local originalSendMessage = modules.game_console.sendMessage

-- modules.game_console.sendMessage = function(message)
--   originalSendMessage(message)
--   onSendMessage(message)
-- end






