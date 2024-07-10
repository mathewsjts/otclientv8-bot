local title = "StartSetup"

CaveBot.Extensions[title] = {}

CaveBot.Extensions[title].execute = function(value)
	CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
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
			value = "_",
			title = title,
			description="Setup the script",
			multiline=false
		}
	)
end
