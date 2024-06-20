CaveBot.setSupply = function(slot, min, max, itemId)
  if type(slot) ~= "number" or type(min) ~= "number" or type(max) ~= "number" then return end
  if not min or not max or max < min then return end
  local slotName = "item" .. tostring(slot)
  storage.supplies[slotName .. "Min"] = min
  storage.supplies[slotName .. "Max"] = max
  if type(itemId) == "number" then
    storage.supplies[slotName] = itemId
  end
end
