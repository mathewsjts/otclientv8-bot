outfitSwitcherMacro = macro(100, "Outfit Switcher", "Ctrl+Shift+s", function()
  outfit = player:getOutfit()

  if isBlackListedPlayerInRange(10) then
    if outfit.type ~= 1332 then
      outfit.type = 1332 -- Dragonslayer
      outfit.addons = 3
      player:setOutfit(outfit)
      g_game.changeOutfit(outfit)
    end
  elseif hppercent() < 50 then
    if outfit.type ~= 1332 then
      outfit.type = 1332 -- Dragonslayer
      outfit.addons = 3
      player:setOutfit(outfit)
      g_game.changeOutfit(outfit)
    end
  else
    for _, spec in pairs(getSpectators()) do
      if spec:isMonster() and spec:getHealthPercent() <= 15 and not CaveBot.isHunted then
        if outfit.type ~= 1320 then
          outfit.type = 1320 -- XP
          outfit.addons = 3
          player:setOutfit(outfit)
          g_game.changeOutfit(outfit)
        end
        return
      end
    end

    if outfit.type ~= 1203 then
      outfit.type = 1203 -- Void Master
      outfit.addons = 3
      player:setOutfit(outfit)
      g_game.changeOutfit(outfit)
    end
  end
end)