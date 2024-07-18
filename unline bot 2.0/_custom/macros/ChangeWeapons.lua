local initialWeaponId = 3282
local secondaryWeaponId = 3283

macro(250, "Change Weapons", function()
  local player = g_game.getLocalPlayer()

  if not player then
    return
  end

  local target = player:getTarget()

  if not target then
    return
  end

  if not target:isMonster() then
    return
  end

  local targetHpPercent = target:getHealthPercent()

  if targetHpPercent <= 5 then
    if player:getInventoryItem(GAME_WEAPON_SLOT).getId() ~= secondaryWeaponId then
      g_game.equipItem(player:getInventoryItem(GAME_BACKPACK).getItem(secondaryWeaponId), GAME_WEAPON_SLOT)
    end
  else
    if player:getInventoryItem(GAME_WEAPON_SLOT).getId() ~= initialWeaponId then
      g_game.equipItem(player:getInventoryItem(GAME_BACKPACK).getItem(initialWeaponId), GAME_WEAPON_SLOT)
    end
  end
end)