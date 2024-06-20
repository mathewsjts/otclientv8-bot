local previousOutfit = nil
local lastChangeTime = now
macro(50, "WiseMana", function()
  if hppercent() < 50 then
    -- local outfit = player:getOutfit()

    -- if outfit.type ~= 1332 then
    --   if not previousOutfit then
    --     previousOutfit = table.copy(outfit)
    --   end

    --   outfit.type = 1332
    --   g_game.changeOutfit(outfit)
    -- end

    if manapercent() > 20 and not hasManaShield() and canCast("utamo vita") then
      saySpell("utamo vita")
    end
  elseif hppercent() > 90 then
    -- if previousOutfit and previousOutfit.type ~= 1332 then

    -- if now - lastChangeTime > 200 then
      -- local outfit = player:getOutfit()

      -- if outfit.type ~= 1320 then
      --   outfit.type = 1320

      --   g_game.changeOutfit(outfit)
      -- -- else
      -- --   previousOutfit = nil
      -- end
      -- end
    -- end

    if hasManaShield() and canCast("exana vita") then
      saySpell("exana vita")
    end
  end
end)
