-- reset cooldown on die
onTextMessage(function(mode, text)
  if string.find(text:lower(), "you are dead") then
    schedule(1000, function()
      modules.game_cooldown.cooldown = {}
      modules.game_cooldown.cooldowns = {}
      modules.game_cooldown.groupCooldown = {}
    end)
    info("[resetCooldown] Fix cooldown of all spells after die.")
  end
end)


-- reset cooldown on momentum
local MOMENTUM_REDUCTION_VALUE = 2000
onSpellCooldown(function(iconId, duration)
  if duration == 0 then
    modules.game_cooldown.cooldown[iconId] = nil
    local spell, _profile, spellName = modules.gamelib.Spells.getSpellByIcon(iconId)

    if spell then
      for group, groupDuration in pairs(spell.group) do
        if groupDuration / 2 > MOMENTUM_REDUCTION_VALUE then
          schedule(100, function()
            modules.game_cooldown.groupCooldown[group] = nil
          end)
          info("[resetCooldown] Fix cooldown of the group spell " .. group .. " and spell " .. spellName .. ".")
        end
      end
    else
      modules.game_cooldown.groupCooldown = {}
      info("[resetCooldown] Fix cooldown of an unknown spell with iconId " .. iconId .. ".")
    end
  end
end)

-- debug momentum cooldown reduction
-- local elapsedTime = now
-- onSpellCooldown(function(iconId, duration)
--   if iconId == 179 then -- 179 = Fury of Nature spell
--     if duration < 20000 then
--       info("Time Elapsed: " .. now - elapsedTime)
--       info("Spell ID: " .. iconId)
--       info("New Cooldown After Momentum: " .. duration)
--       elapsedTime = now
--     else
--       elapsedTime = now
--     end
--   end
-- end)
