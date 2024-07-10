local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text
local profileFile = "/bot/" .. configName .. "/vBot_configs/".. player:getName() .."/Profile.json"

ProfileConfig = MainConfig.loadConfigFile(profileFile) or {
  currentProfile = "__configuration",
	activeProfile = "",
}

ProfileManager = {}

ProfileManager.reload = function()
  local profile = ProfileConfig.currentProfile
  ProfileManager.setCurrentProfile(ProfileConfig.currentProfile)
end

ProfileManager.setCurrentProfile = function(profile)
  ProfileConfig.currentProfile = profile
  if not string.find(profile, "__") then
    TargetBot.setCurrentProfile(profile)
  end
  CaveBot.setCurrentProfile(profile)
  MainConfig.saveConfigFile(profileFile, ProfileConfig)
end

ProfileManager.setActiveProfile = function(profile)
	ProfileConfig.activeProfile = profile
end

ProfileManager.reload()
