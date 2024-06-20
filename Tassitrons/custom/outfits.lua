

local function outfitTemplate()
  local outfit = player:getOutfit()
  outfit.head = 114
  outfit.body = 38
  outfit.legs = 57
  outfit.addons = 3
  return outfit
end

local function dismountAfterFly()
  if player:getOutfit().mount == 1404 then
    player:dismount()
  end
end

addIcon("Loot",
  {outfit={mount=0,head=78,body=106,legs=116,feet=95,type=1280,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = outfitTemplate()
    outfit.type = 1280
    -- outfit = {mount=0,head=78,body=106,legs=116,feet=95,type=1280,addons=3,auxType=0}
    outfitMock = outfit
    -- player:setOutfit(outfitMock)
    g_game.changeOutfit(outfit)
end)

addIcon("Damage Protection",
  {outfit={mount=0,head=78,body=106,legs=116,feet=95,type=1332,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = outfitTemplate()
    outfit.type = 1332
    -- outfit = {mount=0,head=78,body=106,legs=116,feet=95,type=1332,addons=3,auxType=0}
    outfitMock = outfit
    -- player:setOutfit(outfitMock)
    g_game.changeOutfit(outfit)
end)

addIcon("Assassin",
  {outfit={mount=0,head=78,body=106,legs=116,feet=95,type=156,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = outfitTemplate()
    outfit.type = 156
    -- outfit = {mount=0,head=78,body=106,legs=116,feet=95,type=156,addons=3,auxType=0}
    outfitMock = outfit
    -- player:setOutfit(outfitMock)
    g_game.changeOutfit(outfit)
end)

addIcon("SoulWar XP",
  {outfit={mount=0,head=114,body=38,legs=57,feet=95,type=1320,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = outfitTemplate()
    outfit.type = 1320
    -- outfit = {mount=0,head=114,body=38,legs=57,feet=95,type=1320,addons=3,auxType=0}
    outfitMock = outfit
    -- player:setOutfit(outfitMock)
    g_game.changeOutfit(outfit)
end)

addIcon("Boost Physical",
  {outfit={mount=0,head=114,body=38,legs=57,feet=95,type=1207,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = outfitTemplate()
    outfit.type = 1207
    g_game.changeOutfit(outfit)
end)

addIcon("Golden Outfit",
  {outfit={mount=0,head=114,body=38,legs=57,feet=95,type=1211,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = outfitTemplate()
    outfit.type = 1211
    g_game.changeOutfit(outfit)
end)

addIcon("Camelizer",
  {outfit={mount=0,head=114,body=38,legs=57,feet=95,type=150,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = outfitTemplate()
    outfit.type = 150
    g_game.changeOutfit(outfit)
end)

addIcon("Witch",
  {outfit={mount=0,head=114,body=38,legs=57,feet=95,type=54,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    outfit = outfitTemplate()
    outfit.type = 54
    outfit.mount = 0
    outfit.addons = 0

    g_game.changeOutfit(outfit)
end)

addIcon("Manaleech Mount",
  {outfit={type=849,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = player:getOutfit()
    outfit.mount = 849
    outfitMock = outfit
    g_game.changeOutfit(outfit)
    player:mount()
end)

addIcon("Store Discount Mount",
  {outfit={type=571,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = player:getOutfit()
    outfit.mount = 571
    outfitMock = outfit
    g_game.changeOutfit(outfit)
    player:mount()
end)

addIcon("Fly Mount",
  {outfit={type=1404,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    outfit = player:getOutfit()
    outfit.mount = 1404
    outfitMock = outfit
    g_game.changeOutfit(outfit)
    player:mount()
end)

addIcon("Boost Physical Mount",
  {outfit={type=1399,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    outfit = player:getOutfit()
    outfit.mount = 1399
    outfitMock = outfit
    g_game.changeOutfit(outfit)
    player:mount()
end)

addIcon("Drunk Immunity Mount",
  {outfit={type=368,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = player:getOutfit()
    outfit.mount = 368
    outfitMock = outfit
    g_game.changeOutfit(outfit)
    player:mount()
end)

addIcon("Drommedary Mount",
  {outfit={type=405,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = player:getOutfit()
    outfit.mount = 405
    outfitMock = outfit
    g_game.changeOutfit(outfit)
    player:mount()
end)

addIcon("Freeze Mount",
  {outfit={type=631,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = player:getOutfit()
    outfit.mount = 631
    outfitMock = outfit
    g_game.changeOutfit(outfit)
    player:mount()
end)

addIcon("Fearless Mount",
  {outfit={type=736,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = player:getOutfit()
    outfit.mount = 736
    outfitMock = outfit
    g_game.changeOutfit(outfit)
    player:mount()
end)

addIcon("XP Mount",
  {outfit={type=1323,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = player:getOutfit()
    outfit.mount = 1323
    outfitMock = outfit
    g_game.changeOutfit(outfit)
    player:mount()
end)

addIcon("Loot Mount",
  {outfit={type=559,addons=3,auxType=0}, movable=true, switchable=false},
  function(widget, enabled)
    dismountAfterFly()
    outfit = player:getOutfit()
    outfit.mount = 559
    outfitMock = outfit
    g_game.changeOutfit(outfit)
    player:mount()
end)
