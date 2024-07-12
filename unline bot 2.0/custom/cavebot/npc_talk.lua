local = "NpcTalk"

CaveBot.Extensions[title] = {}

CaveBot.Extensions[title].execute = function(value, retries)
	local messages = string.split(value, ",")
	local npcName = messages[1]:trim()
	local npc = getCreatureByName(npcName)

	if retries > 10 then
		print("CaveBot[NpcTalk]: Too many tries, can't talk")
		return false
	end

	if not npc then
		print("CaveBot[NpcTalk]: NPC not found")
		return false
	end

	if not CaveBot.ReachNPC(npcName) then
		return "retry"
	end

	local expressions = {"hi"}
	for index, message in ipairs(messages) do
		if index > 1 then
			table.insert(expressions, message:trim())
		end
	end

	CaveBot.ConversationList(expressions)
	CaveBot.ConversationDelay(#expressions + 1)

	return true
end

CaveBot.Extensions[title].setup = function()
  CaveBot.registerAction(
		title,
		"#ffffff",
		CaveBot.Extensions[title].execute
	)

  CaveBot.Editor.registerAction(
		title,
		title,
		{
			value = "npcName,message1,message2",
			title = title,
			description = "messages to talk separated by comma (,)",
			multiline = false
  	}
	)
end
