local function resetCooldowns()
	modules.game_cooldown.cooldown = {}
	modules.game_cooldown.cooldowns = {}
	modules.game_cooldown.groupCooldown = {}
end

resetCooldowns()

onTextMessage(function(mode, text)
	local lowerText = text:lower()
	if lowerText:find("you are dead") then
		schedule(100, resetCooldowns)
	end
end)
