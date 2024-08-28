local petBodies = {10221,10222,10223,10224}

macro(500, "Revive Pet", function()
  if not isInPz() then
    for i, tile in ipairs(g_map.getTiles(posz())) do
      for u, item in ipairs(tile:getItems()) do
        if table.find(petBodies, item:getId()) and findItem(34234) then
          useWith(34234, item)
        end
      end
    end
  end
end)
