local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text
local profileFile = "/bot/" .. configName .. "/vBot_configs/".. player:getName() .."/Profile.json"

ProfileConfig = MainConfig.loadConfigFile(profileFile) or {
	activeProfile = "",
  currentProfile = "__configuration",
	quickloot = "",
	sellLoot = {},
	weaponId = "",
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

ProfileManager.getActiveProfile = function()
	return ProfileConfig.activeProfile
end

ProfileManager.setActiveProfile = function(profile)
	ProfileConfig.activeProfile = profile
  MainConfig.saveConfigFile(profileFile, ProfileConfig)
end

ProfileManager.getQuickloot = function(quickloot)
	return ProfileConfig.quickloot
end

ProfileManager.setQuickloot = function(quickloot)
	ProfileConfig.quickloot = quickloot
  MainConfig.saveConfigFile(profileFile, ProfileConfig)
end

ProfileManager.setSellLoot = function(cities)
	ProfileConfig.sellLoot = cities
  MainConfig.saveConfigFile(profileFile, ProfileConfig)
end

ProfileManager.getWeaponId = function()
	return ProfileConfig.weaponId
end

ProfileManager.setWeaponId = function(weaponId)
	ProfileConfig.weaponId = weaponId
  MainConfig.saveConfigFile(profileFile, ProfileConfig)
end

ProfileManager.reload()
