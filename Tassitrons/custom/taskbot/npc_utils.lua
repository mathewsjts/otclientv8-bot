local panelName = "supplies"
local currentProfile = SuppliesConfig[panelName].currentProfile

CaveBot.setSupply = function(slot, min, max, itemId)
  if type(slot) ~= "number" or type(min) ~= "number" or type(max) ~= "number" then return end
  if not min or not max or max < min then return end
  local slotName = "item" .. tostring(slot)

  SuppliesConfig[panelName][currentProfile].items[itemId] = {
    min = min,
    max = max,
    avg = 0,
  }
  -- storage.supplies[slotName .. "Min"] = min
  -- storage.supplies[slotName .. "Max"] = max
  -- if type(itemId) == "number" then
  --   storage.supplies[slotName] = itemId
  -- end
end

TaskBot.ferryTravel = function(destination, wait)
  if (type(wait) ~= "number") then
    wait = 200
  end

  sayNpc("hi")
  schedule(wait, function() sayNpc(destination) end)
  schedule(2*wait, function() sayNpc("yes") end)
  delay(3*wait)
end

TaskBot.setAGCity = function(destination, wait)
  if (type(wait) ~= "number") then
    wait = 300
  end

  local npc = getCreatureByName("Charos")

  if not npc then
    print("CaveBot[Travel]: NPC not found.")
    return false
  end

  local pos = player:getPosition()
  local npcPos = npc:getPosition()
  if math.max(math.abs(pos.x - npcPos.x), math.abs(pos.y - npcPos.y)) > 3 then
    CaveBot.walkTo(npcPos, 20, {ignoreNonPathable = true, precision=3})
    delay(300)
    return "retry"
  end

  if (math.max(math.abs(pos.x - npcPos.x), math.abs(pos.y - npcPos.y)) < 4) then
    sayNpc("hi")
    schedule(wait, function() sayNpc("yes") end)
    schedule(2 * wait, function() sayNpc(destination) end)
  end

  return true
end

TaskBot.buyAdventurerStone = function(wait)
  if (type(wait) ~= "number") then
    wait = 300
  end

  local npc = getCreatureByName("Quentin")

  if not npc then
    print("CaveBot[Travel]: NPC not found.")
    return false
  end

  local pos = player:getPosition()
  local npcPos = npc:getPosition()
  if math.max(math.abs(pos.x - npcPos.x), math.abs(pos.y - npcPos.y)) > 3 then
    CaveBot.walkTo(npcPos, 20, {ignoreNonPathable = true, precision=3})
    delay(300)
    return "retry"
  end

  if (math.max(math.abs(pos.x - npcPos.x), math.abs(pos.y - npcPos.y)) < 4) then
    sayNpc("hi")
    schedule(wait, function() sayNpc("adventurer stone") end)
    schedule(2 * wait, function() sayNpc("yes") end)
  end

  return true
end

TaskBot.buyItem = function(npcName, itemID, maxAmount)
  local possibleItems = {}

  -- local val = string.split(value, ",")
  -- local itemID
  -- local maxAmount = 1
  -- if #val == 0 or #val > 3 then
  --   warn("CaveBot[BuyItem]: incorrect BuyItem value")
  --   return false
  -- elseif #val == 2 then
  --   itemID = tonumber(val[2]:trim())
  -- elseif #val == 3 then
  --   maxAmount = tonumber(val[3]:trim())
  -- end
  if not maxAmount then
    maxAmount = 1
  end

  local currentAmount
  if itemID and itemID > 100 then
    currentAmount = itemAmount(itemID)
  end

  local npc = getCreatureByName(npcName)
  if not npc then
    print("CaveBot[BuyItem]: NPC not found")
    return false
  end

  local pos = player:getPosition()
  local npcPos = npc:getPosition()
  if math.max(math.abs(pos.x - npcPos.x), math.abs(pos.y - npcPos.y)) > 3 then
    CaveBot.walkTo(npcPos, 20, {ignoreNonPathable = true, precision=3})
    delay(300)
    return "retry"
  end

  if not NPC.isTrading() then
    delay(300)
    NPC.say("hi")
    schedule(500, function() NPC.say("trade") end)
    return "retry"
  end

  local npcItems = NPC.getBuyItems()
  for i,v in pairs(npcItems) do
    table.insert(possibleItems, v.id)
  end

  delay(500)

  if itemID and itemID > 100 and table.find(possibleItems, itemID) then
    local amountToBuy = maxAmount - currentAmount
    if amountToBuy > 100 then
      for i=1, math.ceil(amountToBuy/100), 1 do
        NPC.buy(itemID, math.min(100, amountToBuy))
        print("CaveBot[BuyItem]: bought " .. amountToBuy .. "x " .. itemID)
        return "retry"
      end
    elseif amountToBuy > 0 then
      NPC.buy(itemID, math.min(100, amountToBuy))
      print("CaveBot[BuyItem]: bought " .. amountToBuy .. "x " .. itemID)
      return "retry"
    end
  end

  return true
end

TaskBot.balance = 0

local withdrawMoneyMacro = nil
local withdrawMoneyMacroRunning = false
local withdrawAmount = 0
local drawned = false

withdrawMoneyMacro = macro(500, function()
    if TaskBot.balance > 0 then
      local remaining = TaskBot.balance % 10000
      withdrawAmount = TaskBot.balance - remaining - 10000

      if withdrawAmount < 0 then
        withdrawAmount = 1
      end

      schedule(1000, function() sayNpc("withdraw " .. tostring(withdrawAmount)) end)
      schedule(1500, function()
        sayNpc("yes")
        withdrawMoneyMacroRunning = false
      end)
    end
end)

TaskBot.withdrawMoney = function()
  local wait = 500

  if drawned then
    drawned = false
    return true
  end

  if not withdrawMoneyMacroRunning then
    TaskBot.balance = 0
    sayNpc("hi")
    schedule(wait, function() sayNpc("balance") end)
    withdrawMoneyMacro.setOn()
    withdrawMoneyMacroRunning = true
  end
  return "retry"
end

local waiting = false

onTalk(function(name, level, mode, text, channelId, pos)
  if (name == "Ferks") then
    local balance = string.match(text, ".*Your account balance is (%d+) gold.*")
    local drawn = string.match(text, ".*Here you are, (%d+) gold.*")

    if (balance) then
      TaskBot.balance = tonumber(balance)
    end

    if (drawn) then
      withdrawMoneyMacro.setOff()
      drawned = true
    end
  end
end)

TaskBot.joinGrizzlyQuest = function()
  if not TaskBot.hasQuestStarted() then
    local waitVal = 200
    local npc = getCreatureByName("Grizzly Adams")
    if not npc then
      print("CaveBot[Travel]: NPC not found.")
      return false
    end

    local pos = player:getPosition()
    local npcPos = npc:getPosition()
    if math.max(math.abs(pos.x - npcPos.x), math.abs(pos.y - npcPos.y)) > 3 then
      CaveBot.walkTo(npcPos, 20, {ignoreNonPathable = true, precision=3})
      delay(300)
      return "retry"
    end

    sayNpc("hi")
    schedule(waitVal, function() sayNpc("join") end)
    schedule(2* waitVal, function() sayNpc("yes") end)
  end

  return true
end

TaskBot.reportTask = function()
  local waitVal = 200
  local npc = getCreatureByName("Grizzly Adams")
  TaskBot.currentTask = nil

  if not npc then
    print("CaveBot[Travel]: NPC not found.")
    return false
  end

  local pos = player:getPosition()
  local npcPos = npc:getPosition()
  if math.max(math.abs(pos.x - npcPos.x), math.abs(pos.y - npcPos.y)) > 3 then
    CaveBot.walkTo(npcPos, 20, {ignoreNonPathable = true, precision=3})
    delay(300)
    return "retry"
  end

  sayNpc("hi")
  schedule(waitVal, function() sayNpc("report") end)
  delay (2 * waitVal)

  return true
end

TaskBot.buyVagonTicket = function()
  local waitVal = 600
  local npc = getCreatureByName("Gewen")
  if not npc then
    print("CaveBot[Travel]: NPC not found.")
    return false
  end

  local pos = player:getPosition()
  local npcPos = npc:getPosition()
  if math.max(math.abs(pos.x - npcPos.x), math.abs(pos.y - npcPos.y)) > 3 then
    CaveBot.walkTo(npcPos, 20, {ignoreNonPathable = true, precision=3})
    delay(300)
    return "retry"
  end

  sayNpc("hi")
  schedule(waitVal, function() sayNpc("ticket") end)
  schedule(2* waitVal, function() sayNpc("yes") end)
end

TaskBot.joinTheNewFrontier = function()
  local waitVal = 500
  local npc = getCreatureByName("Ongulf")
  if not npc then
    print("CaveBot[Travel]: NPC not found.")
    return false
  end

  local pos = player:getPosition()
  local npcPos = npc:getPosition()
  if math.max(math.abs(pos.x - npcPos.x), math.abs(pos.y - npcPos.y)) > 3 then
    CaveBot.walkTo(npcPos, 20, {ignoreNonPathable = true, precision=3})
    delay(300)
    return "retry"
  end

  sayNpc("hi")
  schedule(waitVal, function() sayNpc("project") end)
  schedule(2* waitVal, function() sayNpc("long") end)
  schedule(3* waitVal, function() sayNpc("mission") end)
  schedule(4* waitVal, function() sayNpc("yes") end)
end
