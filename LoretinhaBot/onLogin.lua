
function isMainBPOpened()
  local containers = g_game.getContainers()

  for _, container in pairs(containers) do
    if not container:hasParent() and container:getName():lower() ~= "store inbox" then
      return true
    end
  end

  return false
end


if true then
  say("!weapon on")
  say("!vial off")

  if not isMainBPOpened() and getBack() then
    g_game.open(getBack())
  end

  g_game.setFightMode(1)
end

local outfitOkButton = rootWidget:recursiveGetChildById("outfitOkButton")

if outfitOkButton then
  outfitOkButton.onClick()
end

local charactersWindow = rootWidget:recursiveGetChildById("charactersWindow")
local autoReconnectButton = charactersWindow:getChildById('autoReconnect')
local characters = charactersWindow:getChildById("characters")

local children = characters:getChildren()
for i=1, #children do
  if children[i].characterName == "Fiora" then
    characters:focusChild(children[i], 1)

    local onLogout = g_game["onLogout"]

    if autoReconnectButton and not autoReconnectButton:isOn() then
      autoReconnectButton.onClick()
    end

    g_game.safeLogout()
    break
  end
end
