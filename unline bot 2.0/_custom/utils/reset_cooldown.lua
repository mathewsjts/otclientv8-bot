local function resetCooldowns()
	modules.game_cooldown.cooldown = {}
	modules.game_cooldown.cooldowns = {}
	modules.game_cooldown.groupCooldown = {}
end

resetCooldowns()

onTextMessage(function(mode, text)
	local lowerText = text:lower()
	local dead = lowerText:find("you are dead")
	local mommentum = lowerText:find("momentum was triggered")
	if dead or mommentum then
		schedule(100, resetCooldowns)
	end
end)
