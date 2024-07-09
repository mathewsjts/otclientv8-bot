CaveBot.Extensions.NpcTalk = {}

CaveBot.Extensions.NpcTalk.setup = function()
	CaveBot.registerAction("NpcTalk", "#ffffff", function(value, retries)
		local messageList = string.split(value, ",")
		local npc_name = messageList[1]:trim()
		local npc = getCreatureByName(npc_name)

		if not npc then
			print("CaveBot[NpcTalk]: NPC not found.")
			return false
		end

		if not CaveBot.ReachNPC(npc_name) then
			return "retry"
		end

		local messages = {"hi"}
		for index, message in ipairs(messageList) do
			if index > 1 then
				table.insert(messages, message)
			end
		end

		CaveBot.ConversationList(messages)
		CaveBot.ConversationDelay(#messages + 1)

		return true
	end)

	CaveBot.Editor.registerAction("npctalk", "npc talk", {
		value="npcName, message1, message2",
		description="messages to talk separated by comma(,)",
		multiline=false
	})
end
