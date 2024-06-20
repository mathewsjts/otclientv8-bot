CaveBot.Extensions.BuyParcel = {}

CaveBot.Extensions.BuyParcel.setup = function()
  CaveBot.registerAction("BuyParcel", "#C300FF", function(value, retries)
    local item1Count = itemAmount(3503)
    local item2Count = itemAmount(3507)
    local possibleItems = {}

    local val = string.split(value, ",")
    local waitVal
    if #val == 0 or #val > 2 then
      warn("CaveBot[BuyParcel]: incorrect BuyParcel value")
      return false
    elseif #val == 2 then
      waitVal = tonumber(val[2]:trim())
    end

    local npc = getCreatureByName(val[1]:trim())
    if not npc then
      print("CaveBot[BuyParcel]: NPC not found")
      return false
    end

    if not waitVal and #val == 2 then
      warn("CaveBot[BuyParcel]: incorrect delay values!")
    elseif waitVal and #val == 2 then
      delay(waitVal)
    end

    if retries > 50 then
      print("CaveBot[BuyParcel]: Too many tries, can't buy")
      return false
    end

    delay(200)

    local pos = player:getPosition()
    local npcPos = npc:getPosition()
    if math.max(math.abs(pos.x - npcPos.x), math.abs(pos.y - npcPos.y)) > 3 then
      CaveBot.walkTo(npcPos, 20, {ignoreNonPathable = true, precision=3})
      delay(300)
      return "retry"
    end

    local itemList = {
        item1 = {ID = 3503, maxAmount = 1, currentAmount = item1Count},
        item2 = {ID = 3507, maxAmount = 1, currentAmount = item2Count},
    }

    if not NPC.isTrading() then
      NPC.say("hi")
      schedule(500, function() NPC.say("trade") end)
      return "retry"
    end

    -- get items from npc
    local npcItems = NPC.getBuyItems()
    for i,v in pairs(npcItems) do
      table.insert(possibleItems, v.id)
    end

    for i, item in pairs(itemList) do
   --   info(table.find(possibleItems, item["ID"]))
     if item["ID"] and item["ID"] > 100 and table.find(possibleItems, item["ID"]) then
      local amountToBuy = item["maxAmount"] - item["currentAmount"]
       if amountToBuy > 100 then
        for i=1, math.ceil(amountToBuy/100), 1 do
         NPC.buy(item["ID"], math.min(100, amountToBuy))
         print("CaveBot[BuyParcel]: bought " .. amountToBuy .. "x " .. item["ID"])
         return "retry"
        end
        else
         if amountToBuy > 0 then
          NPC.buy(item["ID"], math.min(100, amountToBuy))
          print("CaveBot[BuyParcel]: bought " .. amountToBuy .. "x " .. item["ID"])
          return "retry"
         end
       end
      end
     end
    print("CaveBot[BuyParcel]: bought everything, proceeding")
    return true
 end)

 CaveBot.Editor.registerAction("buyparcel", "buy parcel", {
  value="NPC name",
  title="Buy Parcel",
  description="NPC Name, delay(in ms, optional)",
 })
end
