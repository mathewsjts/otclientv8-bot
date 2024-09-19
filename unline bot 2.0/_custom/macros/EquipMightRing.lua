equipMightRing = macro(200, function()
    local targetRingId
    local mightRingId = 3051

    if getSlot(SlotFinger) and getSlot(SlotFinger):getId() ~= mightRingId then
      storage.equipMightRingCustomRing = getSlot(SlotFinger):getId()
    end
    
    if hppercent() <= 60 then
      targetRingId = mightRingId
    else
      targetRingId = storage.equipMightRingCustomRing
    end

    local currentRingId = getSlot(SlotFinger) and getSlot(SlotFinger):getId() or 0
    
    if currentRingId ~= targetRingId then
      g_game.equipItemId(targetRingId)
    end
end)

addIcon("Might Ring", { item = 3051 }, function(icon, isOn)
    equipMightRing.setOn(isOn)
end)
