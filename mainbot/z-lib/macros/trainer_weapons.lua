macro(600000, "trainer weapons", function()
  local bow_id = 3350
  local first_weapon_id = nil
  local second_weapon_id = nil
  
  function to_slot(slot)
    return {x=65535,y=slot,z=0}
  end

  if getLeft():getId() == bow_id then
    if first_weapon_id ~= nil then
      g_game.move(findItem(first_weapon_id), to_slot(SlotLeft), 1)
    end
  
    if second_weapon_id ~= nil then
      g_game.move(findItem(second_weapon_id), to_slot(SlotRight), 1)
    end

    return
  end

  g_game.move(findItem(bow_id), to_slot(SlotLeft), 1)
end)