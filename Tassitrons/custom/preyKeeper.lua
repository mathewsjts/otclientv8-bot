local PREY_ACTION_LISTREROLL = 0
local PREY_ACTION_BONUSREROLL = 1
local PREY_ACTION_MONSTERSELECTION = 2
local PREY_ACTION_REQUEST_ALL_MONSTERS = 3
local PREY_ACTION_CHANGE_FROM_ALL = 4
local PREY_ACTION_LOCK_PREY = 5

preyWindow = rootWidget:recursiveGetChildById("preyWindow")

local preyMonsters = {}

local monster1Coords = nil
local monster2Coords = nil
local monster3Coords = nil

function isPreyActive(slot)
  if preyWindow then
    local slotName = "slot" .. slot
    return preyWindow[slotName].title:getText() ~= "Select monster"
  end

  return false
end

function getMinutesLeft(slot)
  if isPreyActive(slot) then
    local slotName = "slot" .. slot
    local time = preyWindow[slotName].active.creatureAndBonus.timeLeft:getText():split(":")
    local hours = tonumber(time[1])
    local minutes = tonumber(time[2])

    return 60 * hours + minutes
  end

  return 1000
end

function searchOnListBy(slot, monster)
  if preyWindow and monster and not isPreyActive(slot) then
    local slotName = "slot" .. slot
    local list = preyWindow[slotName].inactive.list

    for i, child in pairs(list:getChildren()) do
      if child:getTooltip():lower() == monster then
        return i - 1
      end
    end
  end

  return -1
end

function searchForMonster(monster)
  for i = 1, 3 do
    local index = searchOnListBy(i, monster)
    if index > 0 then
      return {
        slot = i,
        index = index
      }
    end
  end

  return false
end

function isMonsterPreyActive(monsterName)
  if preyWindow then
    for i = 1, 3 do
      local slotName = "slot" .. i

      if preyWindow[slotName].title:getText():lower() == monsterName then
        return true
      end
    end
  end

  return false
end

local preyKeeperMacro = macro(1000, "Prey Keeper", "Ctrl+Shift+p", function()
  for i = 1, 3 do
    if not preyMonsters[i] and isPreyActive(i) then
      local slotName = "slot" .. i
      table.insert(preyMonsters, preyWindow[slotName].title:getText():lower())
    end
  end

  local nextTick = false

  for i = 1, 3 do
    if getMinutesLeft(i) < 5 then
      g_game.preyAction(i - 1, PREY_ACTION_LISTREROLL, 0)
      nextTick = true
      break
    end
  end

  if not nextTick then
    local bucket = {
      isPreyActive(1),
      isPreyActive(2),
      isPreyActive(3),
    }

    local monsters = {}

    for i, monsterName in pairs(preyMonsters) do
      if not isMonsterPreyActive(monsterName) then
        table.insert(monsters, searchForMonster(monsterName))
      end
    end

    local searchCompleted = true

    for i, monster in pairs(monsters) do
      searchCompleted = searchCompleted and monster
    end

    local usedSlots = {}

    if searchCompleted then
      for i, monster in pairs(monsters) do
        if monster and not bucket[monster.slot] and not usedSlots[monster.slot] then
          g_game.preyAction(monster.slot - 1, PREY_ACTION_MONSTERSELECTION, monster.index)
          usedSlots[monster.slot] = true
        end
      end
    else
      for i, monster in pairs(monsters) do
        if monster then
          usedSlots[monster.slot] = true
        end
      end

      for i = 1, 3 do
        if not usedSlots[i] and not bucket[i] then
          g_game.preyAction(i - 1, PREY_ACTION_LISTREROLL, 0)
          break
        end
      end
    end
  end
end)
