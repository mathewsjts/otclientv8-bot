CaveBot.Extensions.BuySupplies = {}

CaveBot.Extensions.BuySupplies.setup = function()
  CaveBot.registerAction("BuySupplies", "#C300FF", function(value, retries)
    local possibleItems = {}

    local val = string.split(value, ",")
    local waitVal
    if #val == 0 or #val > 2 then 
      warn("CaveBot[BuySupplies]: incorrect BuySupplies value")
      return false 
    elseif #val == 2 then
      waitVal = tonumber(val[2]:trim())
    end

    local npcName = val[1]:trim()
    local npc = getCreatureByName(npcName)
    if not npc then 
      print("CaveBot[BuySupplies]: NPC not found")
      return false 
    end
    
    if not waitVal and #val == 2 then 
      warn("CaveBot[BuySupplies]: incorrect delay values!")
    elseif waitVal and #val == 2 then
      delay(waitVal)
    end

    if retries > 50 then
      print("CaveBot[BuySupplies]: Too many tries, can't buy")
      return false
    end

    if not CaveBot.ReachNPC(npcName) then
      return "retry"
    end

    if not NPC.isTrading() then
      CaveBot.OpenNpcTrade()
      CaveBot.delay(storage.extras.talkDelay*2)
      return "retry"
    end

    -- get items from npc
    local npcItems = NPC.getBuyItems()
    for i,v in pairs(npcItems) do
      table.insert(possibleItems, v.id)
    end

    for id, values in pairs(Supplies.getItemsData()) do
      id = tonumber(id)
      if table.find(possibleItems, id) then
        local item_weight = 2.7
        local free_cap = player:getFreeCapacity()
        local max_items_by_cap = math.floor(free_cap / item_weight)
        local items_to_buy = math.min(values.max - player:getItemsCount(id), max_items_by_cap, 100)

        if items_to_buy > 0 then
          NPC.buy(id, items_to_buy)
          print("CaveBot[BuySupplies]: bought " .. items_to_buy .. "x " .. id)
          return "retry"
        end
      end
    end

    print("CaveBot[BuySupplies]: bought everything, proceeding")
    return true
 end)

 CaveBot.Editor.registerAction("buysupplies", "buy supplies", {
  value="NPC name",
  title="Buy Supplies",
  description="NPC Name, delay(in ms, optional)",
 })
end