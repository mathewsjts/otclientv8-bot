macro(250, "change weapons", function()
    local health_percent = 5
    local weapon_kill = 33039

    if not g_game.getAttackingCreature() then
        return
    end

    local creature = g_game.getAttackingCreature()

    if creature:getHealthPercent() > health_percent and itemAmount(storage_custom.weapon_id) > 0 and getLeft():getId() ~= storage_custom.weapon_id then
        g_game.move(findItem(storage_custom.weapon_id), {x=65535, y=SlotLeft, z=0}, 1)
        return
    end

    if creature:getHealthPercent() < health_percent and itemAmount(weapon_kill) > 0 and getLeft():getId() ~= weapon_kill then
        g_game.move(findItem(weapon_kill), {x=65535, y=SlotLeft, z=0}, 1)
        return
    end
  end)