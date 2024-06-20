-- player:isWalking()
-- player:isServerWalking()
local expectedDirs = {}
local isWalking = false
local walkPath = {}
local walkPathIter = 0
local waypoints = {}
local walkerMacro = nil
local dirs = {{NorthWest, North, NorthEast}, {West, 8, East}, {SouthWest, South, SouthEast}}
local pathParams = {
  {},
  { ignoreNonPathable = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  { ignoreNonPathable = true, precision = 2, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  { ignoreNonPathable = true, precision = 3, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  { ignoreNonPathable = true, precision = 4, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  { ignoreNonPathable = true, precision = 5, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  { ignoreNonPathable = true, precision = 6, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  { ignoreNonPathable = true, precision = 7, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  { ignoreNonPathable = true, precision = 8, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  { ignoreNonPathable = true, precision = 9, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  { ignoreNonPathable = true, precision = 10, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  { ignoreNonPathable = true, precision = 1, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
}

hotkey('Ctrl+.', function()
  local point = player:getPosition()
  table.insert(waypoints, player:getPosition())
  info("Insert " .. point.x .. ", " .. point.y .. ", " .. point.z)
end)

resetWalking = function()
  expectedDirs = {}
  walkPath = {}
  isWalking = false
  walkPathIter = 1
end

function canPerformNextStep()
  return #expectedDirs < 4 and walkPath and walkPath[walkPathIter] ~= nil
end

function performNextStep()
  local dir = walkPath[walkPathIter]
  g_game.walk(dir, false)
  table.insert(expectedDirs, dir)
  walkPathIter = walkPathIter + 1
  setMacroDelay(player:getStepDuration(false, dir))
end

doWalking = function()
  if #expectedDirs == 0 then
    return false
  end
  if #expectedDirs > 3 then
    resetWalking()
  end
  local dir = walkPath[walkPathIter]
  if dir then
    g_game.walk(dir, false)
    table.insert(expectedDirs, dir)
    walkPathIter = walkPathIter + 1
    setMacroDelay(player:getStepDuration(false, dir))
    return true
  end
  return false
end

onPlayerPositionChange(function(newPos, oldPos)
  if walkerMacro.isOn() then
    if not oldPos or not newPos then return end
    local dest = waypoints[1]

    if dest and dest.x == newPos.x and dest.y == newPos.y and dest.z == newPos.z then
      info("Dest reached")
      table.remove(waypoints, 1)
    end

    local dir = dirs[newPos.y - oldPos.y + 2]
    if dir then
      dir = dir[newPos.x - oldPos.x + 2]
    end
    if not dir then
      dir = 8 -- 8 is invalid dir, it's fine
    end

    if not isWalking or not expectedDirs[1] then
      -- some other walk action is taking place (for example use on ladder), wait
      walkPath = {}
      setMacroDelay(player:getStepDuration(false, dir) + 150)
      return
    end

    if expectedDirs[1] ~= dir then
      setMacroDelay(player:getStepDuration(false, dir))
      return
    end

    table.remove(expectedDirs, 1)
  end
end)

local function handleTheNextWaypoint()
  resetWalking()

  local waypoint = waypoints[1]
  local foundPath = false
  for _, params in pairs(pathParams) do
    walkPath = getPath(player:getPosition(), waypoint, 50, params)

    if walkPath and walkPath[1] then
      isWalking = true
      -- foundPath = true
      break
    end
  end
end

walkTo = function(dest, maxDist, params)
  local path = getPath(player:getPosition(), dest, maxDist, params)
  if not path or not path[1] then
    return false
  end
  local dir = path[1]

  g_game.walk(dir, false)
  isWalking = true
  walkPath = path
  walkPathIter = 2
  expectedDirs = { dir }
  setMacroDelay(player:getStepDuration(false, dir))
  return true
end

walkerMacro = macro(50, "Follow", "Ctrl+f", function()
  if canPerformNextStep() then
    performNextStep()
  elseif #waypoints > 0 then
    handleTheNextWaypoint()
    -- resetWalking()
    -- walkTo(waypoints[1], 50, {})
  elseif #walkPath > 0 then
    resetWalking()
  end
  -- if doWalking() then return end

  -- local waypoint = waypoints[1]
  -- if waypoint then
  --   -- resetWalking()
  --   walkTo(waypoint, 50, {})
  -- end
end)

local setOn = walkerMacro.setOn

walkerMacro.setOn = function()
  setOn()
  info("Running walker bot")
end

function setMacroDelay(time)
  walkerMacro.delay = math.max(walkerMacro.delay or 0, now + time)
end

