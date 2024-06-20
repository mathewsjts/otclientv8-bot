dofile("/custom/followbot/actionSystem.lua")

local LEADER = "LEADER"
local FOLLOWER = "FOLLOWER"
local currentRole = nil
local listeners = {}
local leader = nil
CommunicationSystem = {}
CommunicationSystem.leaderUpdatesListener = function() end
CommunicationSystem.LEADER = LEADER
CommunicationSystem.FOLLOWER = FOLLOWER

CommunicationSystem.getRole = function()
  return currentRole
end

CommunicationSystem.setRole = function(role)
  if role == LEADER or role == FOLLOWER then
    currentRole = role
    return
  end

  warn("The role must to be " .. LEADER .. " or " .. FOLLOWER .. ".")
end

CommunicationSystem.addListener = function(callback)

end

CommunicationSystem.listen = function(playerName)
  leader = playerName:lower()
  BotServer.send("followRequest", playerName)
end

-- SERVER SIDE
local initialized = false
local function initialize()
  initialized = true

  ActionSystem.registerObserverToAction(ActionSystem.ON_WALK, function(position)
    info("Sending Position: " .. position.x .. ", " .. position.y .. ", " .. position.z)
    BotServer.send("leaderPosition", position)
  end)

  ActionSystem.registerObserverToAction(ActionSystem.ON_TELEPORT, function(position)
    info("Sending Position: " .. position.x .. ", " .. position.y .. ", " .. position.z)
    BotServer.send("leaderPosition", position)
  end)

  ActionSystem.registerObserverToAction(ActionSystem.ON_INVENTORY_USE, function(itemId)
    BotServer.send("useItem", itemId)
  end)

  ActionSystem.registerObserverToAction(ActionSystem.ON_GROUND_USE, function(usedThing)
    BotServer.send("groundUse", usedThing)
  end)

  ActionSystem.registerObserverToAction(ActionSystem.ON_GROUND_USE_WITH, function(usedThing)
    info("Sending ground use with: " .. usedThing.id .. ", " .. usedThing.position.x .. ", " .. usedThing.position.y .. ", " .. usedThing.position.z)
    BotServer.send("groundUseWith", usedThing)
  end)

  ActionSystem.registerObserverToAction(ActionSystem.ON_PLAYER_ATTACK, function(playerId)
    BotServer.send("attackPlayer", playerId)
  end)

  ActionSystem.registerObserverToAction(ActionSystem.ON_ATTACK, function(monsterId)
    BotServer.send("attackMonster", monsterId)
  end)

  ActionSystem.registerObserverToAction(ActionSystem.ON_STOP_ATTACK, function()
    BotServer.send("stopAttack")
  end)

  -- ActionSystem.registerObserverToAction(ActionSystem.ON_GROUND_USE, function(pos, itemId)
  --   BotServer.send("useItem", {
  --     ["pos"] = pos,
  --     ["itemId"] = itemId,
  --   })
  -- end)
end





-- CLIENT SIDE
BotServer.listen("followRequest", function(name, message)
  if message:lower() == player:getName():lower() then
    -- CommunicationSystem.setRole(LEADER)
    if not initialized then initialize() end
    info(name .. " is following you.")
  end
end)

BotServer.listen("stopFollow", function(name, message)
  if message:lower() == player:getName():lower() then
    CommunicationSystem.setRole(LEADER)
    info(name .. " is following you.")
  end
end)

BotServer.listen("leaderPosition", function(name, message)
  if leader and name:lower() == leader:lower() then
    -- info("Received Position: " .. message.x .. ", " .. message.y .. ", " .. message.z)
    -- if #listeners["walk"] > 0 then
    local action = {
      ["type"]      = "walk",
      ["finished"]  = false,
      ["position"]  = message,
      ["dest"]      = message,
    }

    CommunicationSystem.leaderUpdatesListener(action)
    -- end
  end
end)

BotServer.listen("useItem", function(name, itemId)
  if leader and name:lower() == leader:lower() then
    local action = {
      ["type"]      = "useItem",
      ["finished"]  = false,
      ["itemId"]    = itemId,
    }

    CommunicationSystem.leaderUpdatesListener(action)
  end
end)

BotServer.listen("groundUse", function(name, usedThing)
  if leader and name:lower() == leader:lower() then
    local action = {
      ["type"]      = "groundUse",
      ["finished"]  = false,
      ["itemId"]    = usedThing.id,
      ["position"]    = usedThing.position,
    }

    CommunicationSystem.leaderUpdatesListener(action)
  end
end)

BotServer.listen("groundUseWith", function(name, usedThing)
  if leader and name:lower() == leader:lower() then
    local action = {
      ["type"]      = "groundUseWith",
      ["finished"]  = false,
      ["itemId"]    = usedThing.id,
      ["position"]    = usedThing.position,
    }

    CommunicationSystem.leaderUpdatesListener(action)
  end
end)

BotServer.listen("attackPlayer", function(name, playerId)
  if leader and name:lower() == leader:lower() then
    local action = {
      ["type"]      = "attackPlayer",
      ["finished"]  = false,
      ["creatureId"]    = playerId,
    }

    CommunicationSystem.leaderUpdatesListener(action)
  end
end)

BotServer.listen("attackMonster", function(name, monsterId)
  if leader and name:lower() == leader:lower() then
    local action = {
      ["type"]      = "attackMonster",
      ["finished"]  = false,
      ["creatureId"]    = monsterId,
    }

    CommunicationSystem.leaderUpdatesListener(action)
  end
end)

BotServer.listen("stopAttack", function(name)
  if leader and name:lower() == leader:lower() then
    local action = {
      ["type"]      = "stopAttack",
      ["finished"]  = false,
    }

    CommunicationSystem.leaderUpdatesListener(action)
  end
end)






