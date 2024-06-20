

TaskBot.ferryTravel = function(destination, wait)
  if (type(wait) ~= "number") then
    wait = 200
  end

  sayNpc("hi")
  schedule(wait, function() sayNpc(destination) end)
  schedule(2*wait, function() sayNpc("yes") end)
  delay(3*wait)
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
