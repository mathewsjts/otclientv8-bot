local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text
local attackBotFile = "/bot/" .. configName .. "/vBot_configs/".. player:getName() .."/AttackBot.json"

if MainConfig.isConfigFile(attackBotFile) then
  AttackBotConfig = MainConfig.loadConfigFile(attackBotFile) or {}
  MainConfig.saveConfigFile(attackBotFile, AttackBotConfig)
end

local originalFunction = {
  vBotConfigSave = vBotConfigSave
}

function vBotConfigSave(param)
  if param == "atk" then
    MainConfig.saveConfigFile(attackBotFile, AttackBotConfig)
    return
  end
  return originalFunction.vBotConfigSave(param)
end
