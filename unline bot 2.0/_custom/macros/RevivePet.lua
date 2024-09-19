macro(500, "Revive Pet", function()
  if not isInPz() then
		local reviveHerbId = 34234
		local petBodies = {10221,10222,10223,10224}

    if itemAmount(reviveHerbId) < 1 then
      return
    end
    for i, tile in ipairs(g_map.getTiles(posz())) do
      for u, item in ipairs(tile:getItems()) do
        if table.find(petBodies, item:getId()) and findItem(reviveHerbId) then
          useWith(reviveHerbId, item)
        end
      end
    end
  end
end)
