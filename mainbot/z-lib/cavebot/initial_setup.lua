CaveBot.Extensions.InitialSetup = {}

CaveBot.Extensions.InitialSetup.setup = function()
  CaveBot.registerAction("InitialSetup", "#ffffff", function(value)
    local loot_seller_cities = {}
    local value_split = string.split(value, ",")
    local supply_data = Supplies.hasEnough()
    local supply_info = Supplies.getAdditionalData()
    local has_blessings = player:getBlessings() > 0
    local has_to_refill = storage.caveBot.forceRefill
                        or storage.caveBot.backStop
                        or storage.caveBot.backTrainers
                        or storage.caveBot.backOffline
                        or type(supply_data) == "table"
                        or (supply_info.capacity.enabled and freecap() < tonumber(supply_info.capacity.value))
                        or (supply_info.stamina.enabled and stamina() < tonumber(supply_info.stamina.value))

    if storage_custom.cavebot_profile ~= CaveBot.getCurrentProfile() then
      stg_custom.set_data("cavebot_profile", CaveBot.getCurrentProfile())
    end

    for _, city_name in pairs(value_split) do
      if city_name:trim() ~= "_" then
        table.insert(loot_seller_cities, city_name:trim())
      end
    end

    stg_custom.set_data("loot_seller_cities", loot_seller_cities)

    if not getLeft() then
      g_game.move(findItem(storage_custom.weapon_id), {x=65535, y=SlotLeft, z=0}, 1)
    end

    TargetBot.setCurrentProfile(CaveBot.getCurrentProfile())

    if not has_blessings or has_to_refill then
      TargetBot.setCurrentProfile("__configuration")
      CaveBot.setCurrentProfile("__configuration")
    end

    CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
    return true
  end)

  CaveBot.Editor.registerAction("initialsetup", "initial setup", {
    value="_",
    title="Initial Setup",
    description="check refill properties",
    multiline=false
  })
end
