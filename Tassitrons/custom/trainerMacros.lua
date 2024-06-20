setDefaultTab("Tools")

northMacro = nil
southMacro = nil
eastMacro = nil
westMacro = nil

enhanceMagicMacro = macro(5000, "enhance magic", function()
  if manapercent() > 60 then
    saySpell("adeta res")
  end
end)

eastMacro = macro(500, "Train ML", "Ctrl+Shift+right", function()
  if mana() > 20000 then
    turn(0)
    say("utevo rexo vis")
    turn(2)
    say("utevo rexo vis")
    turn(3)
    say("utevo rexo vis")
    turn(1)
    say("utevo rexo vis")
  else
    turn(1)
  end
end)

local defaultEastMacroSetOn = eastMacro.setOn

eastMacro.setOn = function(val)
  westMacro.setOff()
  northMacro.setOff()
  southMacro.setOff()
  defaultEastMacroSetOn(val)
end

westMacro = macro(500, "Train ML", "Ctrl+Shift+left", function()
  if mana() > 20000 then
    turn(0)
    say("utevo rexo vis")
    turn(2)
    say("utevo rexo vis")
    turn(1)
    say("utevo rexo vis")
    turn(3)
    say("utevo rexo vis")
  else
    turn(3)
  end
end)

local defaultWestMacroSetOn = westMacro.setOn

westMacro.setOn = function(val)
  eastMacro.setOff()
  northMacro.setOff()
  southMacro.setOff()
  defaultWestMacroSetOn(val)
end

local northSides = {[0] = 0, [1] = 3, [2] = 1}
local northCurrentSide = 0

northMacro = macro(500, "Train ML", "Ctrl+Shift+up", function()
  if manapercent() > 55 then
    local nextSide = (northCurrentSide + 1) % 3
    turn(northSides[nextSide])
    say("utevo rexo vis")
    turn(3)
    say("utevo rexo vis")
    turn(2)
    say("utevo rexo vis")
    turn(0)
    say("utevo rexo vis")
    northCurrentSide = nextSide
  else
    turn(0)
  end
end)

local defaultNorthMacroSetOn = northMacro.setOn

northMacro.setOn = function(val)
  eastMacro.setOff()
  westMacro.setOff()
  southMacro.setOff()
  defaultNorthMacroSetOn(val)
end

local sides = {[0] = 0, [1] = 2}
local currentSide = 1
southMacro = macro(500, "Train ML", "Ctrl+Shift+down", function()
  if manapercent() > 55 then
    local nextSide = (currentSide + 1) % 2
    turn(3)
    say("utevo rexo vis")
    turn(sides[nextSide])
    say("utevo rexo vis")
    turn(sides[currentSide])
    say("utevo rexo vis")
    turn(1)
    say("utevo rexo vis")
    turn(sides[nextSide])
    say("utevo rexo vis")
    currentSide = nextSide
  else
    turn(2)
  end
end)

local defaultSouthMacroSetOn = southMacro.setOn

southMacro.setOn = function(val)
  eastMacro.setOff()
  westMacro.setOff()
  northMacro.setOff()
  defaultSouthMacroSetOn(val)
end
