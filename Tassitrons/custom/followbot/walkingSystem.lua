-- player:isWalking()
-- player:isServerWalking()
WalkingSystem = {}
local expectedDirs = {}
local isWalking = false
local walkPath = {}
local walkPathIter = 0
local waypoints = {}
local dest = nil
local stepPerformed = false
local walkerMacro = nil
local timeElapsed = now
local step = 0
local waypointId = 0
local dirs = {{NorthWest, North, NorthEast}, {West, 8, East}, {SouthWest, South, SouthEast}}
local pathParams = {
  {},
  { ignoreNonPathable = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  { ignoreNonPathable = true, precision = 2, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  -- { ignoreNonPathable = true, precision = 3, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  -- { ignoreNonPathable = true, precision = 4, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  -- { ignoreNonPathable = true, precision = 5, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  -- { ignoreNonPathable = true, precision = 6, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  -- { ignoreNonPathable = true, precision = 7, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  -- { ignoreNonPathable = true, precision = 8, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  -- { ignoreNonPathable = true, precision = 9, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  -- { ignoreNonPathable = true, precision = 10, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
  -- { ignoreNonPathable = true, precision = 1, ignoreCreatures = true, allowUnseen = true, allowOnlyVisibleTiles = false },
}

-- Overwrite this
WalkingSystem.onReachDest = function() end
WalkingSystem.setDelay = function() end
WalkingSystem.onFail = function() end
WalkingSystem.onConcludeAction = function() end

hotkey('Ctrl+.', function()
  local point = player:getPosition()
  table.insert(waypoints, player:getPosition())
  info("Insert " .. point.x .. ", " .. point.y .. ", " .. point.z)
end)

local retries = 0
local verifying = false
local positionWasChanged = false

local function getEstimatedStepDuration()
  local stepDuration = 0

  stepDuration = stepDuration + player:getStepDuration(false, 0)
  stepDuration = stepDuration + player:getStepDuration(false, 1)
  stepDuration = stepDuration + player:getStepDuration(false, 2)
  stepDuration = stepDuration + player:getStepDuration(false, 3)
  stepDuration = stepDuration / 4
  stepDuration = stepDuration + 100

  return stepDuration
end

local function whenPositionChange()
  retries = 0
  verifying = false
end

local function verifyCallback()
  if verifying then
    info("Fail because the position not change.")
    WalkingSystem.onFail()
    verifying = false
  end
end

local function verifyAction()
  if not verifying then
    verifying = true
    local timeout = getEstimatedStepDuration()

    schedule(timeout, verifyCallback)
  end
end

local function resetWalking()
  expectedDirs = {}
  walkPath = {}
  isWalking = false
  walkPathIter = 1
end

local function canPerformNextStep()
  return (#expectedDirs < 4 and walkPath and walkPath[walkPathIter] ~= nil) or (dest and dest.t)
end

local actions = {}
local lastStepPerformedAt = now
local function performNextStep()
  if walkPath and (not dest or (not dest.t or stepPerformed or now - lastStepPerformedAt > getEstimatedStepDuration())) then
    local dir = walkPath[walkPathIter]
    if dir then
      g_game.walk(dir, false)
      table.insert(actions, 'walk ' .. dir)
      lastStepPerformedAt = now
      stepPerformed = false
      table.insert(expectedDirs, dir)
      WalkingSystem.setDelay(player:getStepDuration(false, dir))
    end

    walkPathIter = walkPathIter + 1
  end
  -- local delay = now - timeElapsed
  -- timeElapsed = now
  -- step = step + 1
  -- info("w: " .. waypointId .. ", s: " .. step .. ", time: " .. delay .. ", r: " .. tostring(walkPath and (not dest or (not dest.t or stepPerformed))))
end


onPlayerPositionChange(function(newPos, oldPos)
  if not oldPos or not newPos then return end
  stepPerformed = true


  local deltaPos = math.abs(newPos.x - oldPos.x) + math.abs(newPos.y - oldPos.y)
  local deltaZ = math.abs(newPos.z - oldPos.z)
  if deltaPos > 2 or deltaZ > 0 then
    table.insert(actions, 'teleport')
  end

  positionWasChanged = oldPos.x ~= newPos.x or oldPos.y ~= newPos.y or oldPos.z ~= newPos.z
  whenPositionChange()

  local precision = dest and dest.t and 1 or 2

  if
        dest
    and math.abs(dest.x - newPos.x) < precision
    and math.abs(dest.y - newPos.y) < precision
    and dest.z == newPos.z
  then
    info("Dest reached")
    dest = nil
    WalkingSystem.setDelay(0)
    WalkingSystem.onConcludeAction()
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
    WalkingSystem.setDelay(player:getStepDuration(false, dir) + 150)
    -- WalkingSystem.setDelay(player:getStepDuration(false, dir))
    return
  end

  if expectedDirs[1] ~= dir then
    WalkingSystem.setDelay(player:getStepDuration(false, dir))
    return
  end

  table.remove(expectedDirs, 1)
end)

local function handleTheNextWaypoint(waypoint)
  resetWalking()

  if not dest or dest.x ~= waypoint.x or dest.y ~= waypoint.y or dest.z ~= waypoint.z then
    dest = waypoint
    waypointId = waypointId + 1
    step = 0
  end

  if dest and dest.x == pos().x and dest.y == pos().y and dest.z == pos().z then
    info("Dest reached")
    dest = nil
    WalkingSystem.setDelay(0)
    WalkingSystem.onConcludeAction()
    return
  end

  local foundPath = false
  for _, params in pairs(pathParams) do
    walkPath = getPath(player:getPosition(), waypoint, 50, params)

    if walkPath and walkPath[1] then
      isWalking = true
      return
    end
  end
end

WalkingSystem.run = function(waypoint)
  if canPerformNextStep() then
    performNextStep()
  elseif waypoint then
    handleTheNextWaypoint(waypoint)
    performNextStep()
    verifyAction()
  elseif #walkPath > 0 then
    resetWalking()
  end
end

WalkingSystem.stop = function()
  verifying = false
end

local function setMacroDelay(time)
  walkerMacro.delay = math.max(walkerMacro.delay or 0, now + time)
end


hotkey('Shift+l', function()
  local log = ""
  for _, action in ipairs(actions) do
    log = log .. action .. "\n"
  end
  actions = {}
  info(log)
end)

