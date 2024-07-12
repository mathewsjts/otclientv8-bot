local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text
local suppliesFile = "/bot/" .. configName .. "/vBot_configs/".. player:getName() .."/Supplies.json"

if MainConfig.isConfigFile(suppliesFile) then
  SuppliesConfig = MainConfig.loadConfigFile(suppliesFile) or {}
  MainConfig.saveConfigFile(suppliesFile, SuppliesConfig)
end

local originalFunction = {
  vBotConfigSave = vBotConfigSave
}

function vBotConfigSave(param)
  if param == "supply" then
    MainConfig.saveConfigFile(suppliesFile, SuppliesConfig)
  end
  return originalFunction.vBotConfigSave(param)
end
