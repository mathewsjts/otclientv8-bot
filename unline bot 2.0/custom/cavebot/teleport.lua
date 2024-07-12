local title = "Teleport"

CaveBot.Extensions[title] = {}

CaveBot.Extensions[title].execute = function(value)
	local citiesCoords = {
		["aurora"] = {x=5645,y=5605,z=7},
		["dry creek"] = {x=6226,y=4775,z=7},
		["greenville"] = {x=6396,y=4903,z=6},
		["venore"] = {x=32957,y=32076,z=7},
		["thais"] = {x=32369,y=32241,z=7},
		["kazordoon"] = {x=32649,y=31925,z=11},
		["carlin"] = {x=32360,y=31782,z=7},
		["ab dendriel"] = {x=32732,y=31634,z=7},
		["liberty bay"] = {x=32317,y=32826,z=7},
		["port hope"] = {x=32594,y=32745,z=7},
		["ankrahmun"] = {x=33194,y=32853,z=8},
		["darashia"] = {x=33213,y=32454,z=1},
		["edron"] = {x=33217,y=31814,z=8},
		["svargrond"] = {x=32212,y=31132,z=7},
		["yalahar"] = {x=32787,y=31276,z=7},
		["farmine"] = {x=33025,y=31553,z=10},
		["farmine1"] = {x=33025,y=31553,z=14},
		["farmine2"] = {x=33025,y=31553,z=12},
		["gray beach"] = {x=33447,y=31323,z=9},
		["roshamuul"] = {x=0,y=0,z=0},
		["krailos"] = {x=33657,y=31665,z=8},
		["rathleton"] = {x=33594,y=31899,z=6},
		["feyrist"] = {x=33479,y=32230,z=7},
		["issavi"] = {x=33921,y=31477,z=5},
	}
	local cityName = value:trim()
	local cityCoord = citiesCoords[cityName]
	local playerPosition = player:getPosition()
	local maxDistance = 120
	local timeLimit = 240

	if isPoisioned() and canCast("exana pox") then
		cast("exana pox")
	elseif isCursed() and canCast("exana mort") then
		cast("exana mort")
	elseif isBleeding() and canCast("exana kor") then
		cast("exana kor")
	elseif isBurning() and canCast("exana flam") then
		cast("exana flam")
	elseif isEnergized() and canCast("exana vis") then
		cast("exana vis")
	end

	if not storage.custom_timeLimitTeleport then
		storage.custom_timeLimitTeleport = os.time()
	end

	if storage.custom_timeLimitTeleport + timeLimit < os.time() then
		storage.custom_timeLimitTeleport = nil
		return false
	end

	if playerPosition.z ~= cityCoord.z or getDistanceBetween(playerPosition, cityCoord) > maxDistance then
		if cityName == "farmine1" or cityName == "farmine2" then
			cityName = "farmine"
		end
		if cityName == "ab dendriel" then
			cityName = "ab'dendriel"
		end
		NPC.say("!tp " .. cityName)
		return "retry"
	end

	storage.custom_timeLimitTeleport = nil
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
		title, {
			value = "aurora",
			title = title,
			description = "Teleport to a city",
			multiline = false
		}
	)
end
