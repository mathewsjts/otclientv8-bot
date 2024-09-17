if not storage_custom then
  storage_custom = {
    left_weapon_id = "",
    right_weapon_id = "",
    exercise_id = "",
    outfit = "",
    ingame_hotkeys = "",
    last_quickloot = "",
    cavebot_profile = "",
    loot_seller_cities = {},
  }
  vBotConfigSave("storage")
end

stg_custom = {}

stg_custom.set_data = function(key, value)
  storage_custom[key] = value
  vBotConfigSave("storage")
end
