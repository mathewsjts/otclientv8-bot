InteractingSystem = {}

local isUsing = false
local usingInterval = 500
local lastUseTime = now
local usingItemId = nil
local usingSpams = 0
local failed = false
local currentUsingItemId = nil
local lastActionItemUseTime = now


InteractingSystem.onConcludeAction = function() end
InteractingSystem.onFail = function() end
InteractingSystem.setDelay = function() end

local function cleanup()
  isUsing = false
  usingItemId = nil
  usingSpams = 0
  failed = false
end

local function getEstimatedStepDuration()
  local stepDuration = 0

  stepDuration = stepDuration + player:getStepDuration(false, 0)
  stepDuration = stepDuration + player:getStepDuration(false, 1)
  stepDuration = stepDuration + player:getStepDuration(false, 2)
  stepDuration = stepDuration + player:getStepDuration(false, 3)
  stepDuration = stepDuration / 4

  return stepDuration
end

InteractingSystem.use = function(itemId)
  local item = findItem(itemId)
  info("Using item: " .. itemId)

  -- if item then
  if player:isServerWalking() then
    InteractingSystem.setDelay(getEstimatedStepDuration())
    InteractingSystem.onFail()
    info("fail because player is walking.")
  else
    if isUsing then
      InteractingSystem.setDelay(math.max(lastUseTime + usingInterval - now, 100))

      if currentUsingItemId ~= usingItemId then
        InteractingSystem.onFail()
        info("fail because player is using another item.")
      end
    else
      g_game.useInventoryItem(itemId)
      usingItemId = itemId
      schedule(usingInterval, function()
        if not failed then
          if now > lastActionItemUseTime + usingInterval - 50 then
            InteractingSystem.onConcludeAction()
            info("Use item concluded.")
            cleanup()
          else
            InteractingSystem.onFail()
            info("fail because not enough time had elapsed to perform the action.")
          end
        else
          cleanup()
        end
      end)
      InteractingSystem.setDelay(usingInterval + 50)
    end
  end
  -- end
end

InteractingSystem.groundUse = function(itemId, position)
  local tile = g_map.getTile(position)
  local thing = tile:getTopUseThing()
  info("Using item: " .. itemId)

  -- if item then
  if player:isServerWalking() then
    InteractingSystem.setDelay(getEstimatedStepDuration())
    InteractingSystem.onFail()
    info("fail because player is walking.")
  else
    if isUsing then
      InteractingSystem.setDelay(math.max(lastUseTime + usingInterval - now, 100))

      if currentUsingItemId ~= usingItemId then
        InteractingSystem.onFail()
        info("fail because player is using another item.")
      end
    else
      g_game.use(thing)
      -- g_game.useInventoryItem(itemId)
      usingItemId = itemId
      schedule(usingInterval, function()
        if not failed then
          if now > lastActionItemUseTime + usingInterval - 50 then
            if posz() ~= position.z or math.abs(posx() - position.x) > 1 or math.abs(posy() - position.y) > 1 then
              InteractingSystem.onConcludeAction()
              info("Use item concluded.")
              cleanup()
            else
              info("fail because the used item not change player position.")
            end
          else
            InteractingSystem.onFail()
            info("fail because not enough time had elapsed to perform the action.")
          end
        else
          cleanup()
        end
      end)
      InteractingSystem.setDelay(usingInterval + 50)
    end
  end
  -- end
end

InteractingSystem.groundUseWith = function(itemId, position)
  local tile = g_map.getTile(position)
  -- local thing = tile:getTopUseThing()
  info("Using item: " .. itemId)

  -- if item then
  if player:isServerWalking() then
    InteractingSystem.setDelay(getEstimatedStepDuration())
    InteractingSystem.onFail()
    info("fail because player is walking.")
  else
    if isUsing then
      InteractingSystem.setDelay(math.max(lastUseTime + usingInterval - now, 100))

      if currentUsingItemId ~= usingItemId then
        InteractingSystem.onFail()
        info("fail because player is using another item.")
      end
    else
      useWith(itemId, tile:getTopThing())
      usingItemId = itemId
      schedule(usingInterval, function()
        if not failed then
          if now > lastActionItemUseTime + usingInterval - 50 then
            InteractingSystem.onConcludeAction()
            info("Use item concluded.")
            cleanup()
          else
            InteractingSystem.onFail()
            info("fail because not enough time had elapsed to perform the action.")
          end
        else
          cleanup()
        end
      end)
      InteractingSystem.setDelay(usingInterval + 50)
    end
  end
end


macro(50, function()
  isUsing = now < lastUseTime + usingInterval
end)

onUse(function(pos, itemId, stackPos, subType)
  local current = now

  isUsing = true
  currentUsingItemId = itemId

  if not failed then
    if usingSpams > 1 then
      failed = true
      cleanup()
      InteractingSystem.setDelay(usingInterval)
    else
      if itemId == usingItemId then
        if not lastActionItemUseTime then
          lastActionItemUseTime = current
        end
      else
        if current < lastUseTime + usingInterval / 2 then
          failed = true
          cleanup()
          InteractingSystem.setDelay(usingInterval)
        else
          usingSpams = usingSpams + 1
        end
      end
    end
  end

  lastUseTime = current
end)


