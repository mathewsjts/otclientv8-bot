-- Cavebot by otclient@otclient.ovh
-- visit http://bot.otclient.ovh/

local cavebotTab = "Cave"
local targetingTab = storage.extras.joinBot and "Cave" or "Target"

setDefaultTab(cavebotTab)
CaveBot.Extensions = {}
importStyle("/cavebot/cavebot.otui")
importStyle("/cavebot/config.otui")
importStyle("/cavebot/editor.otui")
dofile("/cavebot/actions.lua")
dofile("/cavebot/config.lua")
dofile("/cavebot/editor.lua")
dofile("/cavebot/example_functions.lua")
dofile("/cavebot/recorder.lua")
dofile("/cavebot/walking.lua")
dofile("/cavebot/minimap.lua")
-- in this section you can add extensions, check extension_template.lua
--dofile("/cavebot/extension_template.lua")
dofile("/cavebot/sell_all.lua")
dofile("/cavebot/depositor.lua")
dofile("/cavebot/buy_supplies.lua")
dofile("/cavebot/d_withdraw.lua")
dofile("/cavebot/supply_check.lua")
dofile("/cavebot/travel.lua")
dofile("/cavebot/doors.lua")
dofile("/cavebot/pos_check.lua")
dofile("/cavebot/withdraw.lua")
dofile("/cavebot/inbox_withdraw.lua")
dofile("/cavebot/lure.lua")
dofile("/cavebot/bank.lua")
dofile("/cavebot/clear_tile.lua")
dofile("/cavebot/tasker.lua")
dofile("/cavebot/imbuing.lua")
dofile("/cavebot/stand_lure.lua")

-- custom files
dofile("/_custom/cavebot/buy_item.lua")
dofile("/_custom/cavebot/call_pet.lua")
dofile("/_custom/cavebot/change_floor.lua")
dofile("/_custom/cavebot/change_floor2.lua")
dofile("/_custom/cavebot/check_trainer.lua")
dofile("/_custom/cavebot/exani_hur.lua")
-- dofile("/_custom/cavebot/hidden_hole.lua")
dofile("/_custom/cavebot/initial_setup.lua")
dofile("/_custom/cavebot/npc_talk.lua")
dofile("/_custom/cavebot/set_bot.lua")
dofile("/_custom/cavebot/set_profile.lua")
dofile("/_custom/cavebot/set_quickloot.lua")
dofile("/_custom/cavebot/simple_check.lua")
dofile("/_custom/cavebot/teleport_city.lua")
dofile("/_custom/cavebot/use_trainer.lua")

-- main cavebot file, must be last
dofile("/cavebot/cavebot.lua")

setDefaultTab(targetingTab)
if storage.extras.joinBot then UI.Label("-- [[ TargetBot ]] --") end
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
