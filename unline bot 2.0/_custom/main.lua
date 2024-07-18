MainConfig = {}

local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text

if not g_resources.directoryExists("/bot/".. configName .."/vBot_configs/"..player:getName().."/") then
  g_resources.makeDir("/bot/".. configName .."/vBot_configs/"..player:getName().."/")
end

MainConfig.isConfigFile = function(file)
  return g_resources.fileExists(file)
end

MainConfig.loadConfigFile = function(file)
  if g_resources.fileExists(file) then
    local status, result = pcall(function()
      return json.decode(g_resources.readFileContents(file))
    end)
    if not status then
      return onError("Error while reading config file (" .. file .. "). To fix this problem you can delete HealBot.json. Details: " .. result)
    end
    return result
  end
  return nil
end

MainConfig.saveConfigFile = function(file, config)
  local status, result = pcall(function()
    return json.encode(config, 2)
  end)
  if not status then
    return onError("Error while saving config. it won't be saved. Details: " .. result)
  end
  if result:len() > 100 * 1024 * 1024 then
    return onError("config file is too big, above 100MB, it won't be saved")
  end
  g_resources.writeFileContents(file, result)
end

dofile("/_custom/utils/quest.lua")
dofile("/_custom/utils/reset_cooldown.lua")
dofile("/_custom/utils/setup_storage.lua")