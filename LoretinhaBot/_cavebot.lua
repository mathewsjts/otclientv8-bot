-- Cavebot by otclient@otclient.ovh
-- visit http://bot.otclient.ovh/

local cavebotTab = "Cave"
local targetingTab = "Target"

setDefaultTab(cavebotTab)
CaveBot = {} -- global namespace
CaveBot.Extensions = {}
CaveBot.rookMacro = macro(1000, function()
  if player:getLevel() > 7 then
    CaveBot.gotoLabel("Go Back")
    CaveBot.rookMacro.setOff()
  end
end)
CaveBot.rookMacro.setOff()
importStyle("/cavebot/cavebot.otui")
importStyle("/cavebot/config.otui")
importStyle("/cavebot/editor.otui")
importStyle("/cavebot/supply.otui")
dofile("/cavebot/actions.lua")
dofile("/cavebot/config.lua")
dofile("/cavebot/editor.lua")
dofile("/cavebot/example_functions.lua")
dofile("/cavebot/recorder.lua")
dofile("/cavebot/walking.lua")
-- in this section you can add extensions, check extension_template.lua
--dofile("/cavebot/extension_template.lua")
dofile("/cavebot/sell_all.lua")
dofile("/cavebot/depositor.lua")
dofile("/cavebot/buy_supplies.lua")
dofile("/cavebot/d_withdraw.lua")
dofile("/cavebot/depositer.lua")
dofile("/cavebot/supply.lua")
dofile("/cavebot/supply_check.lua")
dofile("/cavebot/travel.lua")
dofile("/cavebot/doors.lua")
dofile("/cavebot/pos_check.lua")
dofile("/cavebot/withdraw.lua")
dofile("/cavebot/inbox_withdraw.lua")
dofile("/cavebot/lure.lua")
dofile("/cavebot/bank.lua")
dofile("/cavebot/depositer.lua")
dofile("/cavebot/supply.lua")
dofile("/cavebot/clear_tile.lua")
dofile("/cavebot/tasker.lua")
-- main cavebot file, must be last
dofile("/cavebot/cavebot.lua")

setDefaultTab(targetingTab)
TargetBot = {} -- global namespace
importStyle("/targetbot/looting.otui")
importStyle("/targetbot/target.otui")
importStyle("/targetbot/creature_editor.otui")
dofile("/targetbot/creature.lua")
dofile("/targetbot/creature_attack.lua")
dofile("/targetbot/creature_editor.lua")
dofile("/targetbot/creature_priority.lua")
dofile("/targetbot/looting.lua")
dofile("/targetbot/walking.lua")
-- main targetbot file, must be last
dofile("/targetbot/target.lua")

-- Task Bot
TaskBot = {}
dofile("/taskbot/task_config.lua")
dofile("/taskbot/tasks_setup.lua")
dofile("/taskbot/task_tracker.lua")
dofile("/taskbot/npc_utils.lua")
dofile("/taskbot/task_manager.lua")

local text = tostring(g_things.findItemTypeByName("gold coin"):getServerId())

local messageLabel = rootWidget:recursiveGetChildById("middleCenterLabel")
messageLabel:setText(text)
messageLabel:setColor('#ffffff')
messageLabel:setVisible(true)
messageLabel.hideEvent = schedule(math.max(#text * 50, 3000), function() messageLabel:setVisible(false) end)
