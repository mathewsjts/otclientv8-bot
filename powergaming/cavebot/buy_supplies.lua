CaveBot.Extensions.BuySupplies = {}

CaveBot.Extensions.BuySupplies.setup = function()
  CaveBot.registerAction("BuySupplies", "#C300FF", function(value, retries)
    local possible_items = {}
    local npc_name = string.split(value, ",")[1]:trim()
    local npc = getCreatureByName(npc_name)
    local delay = storage.extras.talkDelay or 1000

    if retries > 100 then
      print("CaveBot[BuySupplies]: Too many tries, can't buy")
      return false
    end

    if not npc then
      print("CaveBot[BuySupplies]: NPC not found")
      return false
    end

    if not CaveBot.ReachNPC(npc_name) then
      return "retry"
    end

    if not NPC.isTrading() then
      CaveBot.OpenNpcTrade()
      CaveBot.delay(delay)
      return "retry"
    end

    local npc_items = NPC.getBuyItems()
    for i, v in pairs(npc_items) do
      table.insert(possible_items, v.id)
    end

    for id, values in pairs(Supplies.getItemsData()) do
      item_id = tonumber(id)
      if table.find(possible_items, item_id) then
        local items_to_buy = values.max - player:getItemsCount(item_id)
        items_to_buy = math.min(items_to_buy, 100)

        if items_to_buy > 0 then
          NPC.buy(item_id, items_to_buy)
          CaveBot.delay(delay)
          return "retry"
        end
      end
    end

    print("CaveBot[BuySupplies]: bought everything, proceeding")
    CaveBot.delay(2 * delay)
    return true
 end)

 CaveBot.Editor.registerAction("buysupplies", "buy supplies", {
  value="NPC name",
  title="Buy Supplies",
  description="NPC Name",
 })
end
