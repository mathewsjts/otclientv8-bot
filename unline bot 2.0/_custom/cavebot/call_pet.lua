CaveBot.Extensions.CallPet = {}

CaveBot.Extensions.CallPet.setup = function()
	CaveBot.registerAction("CallPet", "#ffffff", function(value)
        local defaultDelay = 800
        storage.petOn = true
        NPC.say("!pet")
        
        CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping") + defaultDelay)

        if value == "off" and storage.petOn then
            NPC.say("!pet")
        end

        return true
	end)

	CaveBot.Editor.registerAction("callpet", "call pet", {
		value="on",
		title="Call pet",
		description="Call pet (on/off)",
		multiline=false
	})
end

onTalk(function(name, level, mode, text, channelId, pos)
    if text:find("Your pet is dead") then
        storage.petOn = false
    elseif text:find("Your pet is going to sleep") then
        storage.petOn = false
    elseif text:find("Your pet is sleeping") then
        storage.petOn = false
    end
end)
