CaveBot.setSupply = function(slot, min, max, itemId)
  if type(slot) ~= "number" or type(min) ~= "number" or type(max) ~= "number" then return end
  if not min or not max or max < min then return end
  local slotName = "item" .. tostring(slot)
  
  SuppliesConfig[panelName][currentProfile].items[itemId] = {
    min = min,
    max = max,
    avg = 0,
  }
end
