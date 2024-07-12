local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text
local healBotFile = "/bot/" .. configName .. "/vBot_configs/".. player:getName() .."/HealBot.json"

if MainConfig.isConfigFile(healBotFile) then
  HealBotConfig = MainConfig.loadConfigFile(healBotFile) or {}
  MainConfig.saveConfigFile(healBotFile, HealBotConfig)
end

local originalFunction = {
  vBotConfigSave = vBotConfigSave
}

function vBotConfigSave(param)
  if param == "heal" then
    MainConfig.saveConfigFile(healBotFile, HealBotConfig)
  end
  return originalFunction.vBotConfigSave(param)
end
