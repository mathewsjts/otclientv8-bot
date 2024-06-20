

onTextMessage(function(mode, text)
  for _, spec in ipairs(getSpectators()) do
    if spec:isPlayer() and spec ~= player then
      if string.match(text, "You lose") and string.match(text, spec:getName()) then
          outfit = player:getOutfit()
          outfit.mount = 1404
          g_game.changeOutfit(outfit)
          player:mount()
          schedule(500, function()
            say("!fly up")
          end)
        return
      end
    end
  end
end)

macro(50, "FlyOnLowMana", function()
  if manapercent() < 20 then
    outfit = player:getOutfit()
    outfit.mount = 1404
    g_game.changeOutfit(outfit)
    player:mount()
    schedule(500, function()
      say("!fly up")
    end)
  end
end)
