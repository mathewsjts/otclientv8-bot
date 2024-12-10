CaveBot.Extensions.CheckTrainer = {}

CaveBot.Extensions.CheckTrainer.setup = function()
  CaveBot.registerAction("CheckTrainer", "#ffffff", function(value)
    local exercise_list = {34392, 34293, 34294, 34295, 34296, 34297, 34298, 34299, 34300, 34301, 34302, 34303, 41106}
    local label_to_go = string.split(value, ",")[1]:trim()
    local stamina_limit = 2519
    local label_buy_weapon = "buyexerciseweapon"
    local player = g_game.getLocalPlayer()
    local currentOutfit =  player:getOutfit()

    for item_id, _ in pairs(SuppliesConfig.supplies[SuppliesConfig.supplies.currentProfile].items) do
      if table.find(exercise_list, tonumber(item_id)) then
        stg_custom.set_data("exercise_id", tonumber(item_id))
      end
    end

    if player:getOutfit().type ~= 1186 then
      stg_custom.set_data("outfit", tonumber(player:getOutfit().type))
      currentOutfit.type = 1186
      currentOutfit.head = 1
      currentOutfit.body = 114
      currentOutfit.legs = 114
      currentOutfit.feet = 114
			currentOutfit.addons = 3
      g_game.changeOutfit(currentOutfit)
      CaveBot.delay(500)
    end

    if itemAmount(storage_custom.exercise_id) < 1 then
      CaveBot.gotoLabel(label_buy_weapon)
      return true
    end

    if getLeft() and getLeft():getId() ~= storage_custom.exercise_id then
      stg_custom.set_data("left_weapon_id", getLeft():getId())
      CaveBot.delay(500)
    end

    if voc() == 15 and getRight() and getRight():getId() ~= storage_custom.exercise_id then
      stg_custom.set_data("right_weapon_id", getRight():getId())
    end

    if getLeft() and getLeft():getId() == storage_custom.left_weapon_id and stamina() < stamina_limit then
      g_game.move(getLeft(), {x=65535, y=SlotBack, z=0}, 1)
      CaveBot.delay(500)
    end

    if voc() == 15 and getRight() and getRight():getId() == storage_custom.right_weapon_id and stamina() < stamina_limit then
      g_game.move(getRight(), {x=65535, y=SlotBack, z=0}, 1)
    end

    if stamina() > stamina_limit then
      g_game.move(findItem(storage_custom.left_weapon_id), {x=65535, y=SlotLeft, z=0}, 1)
      CaveBot.delay(500)

      if voc() == 15 then
        g_game.move(findItem(storage_custom.right_weapon_id), {x=65535, y=SlotRight, z=0}, 1)
        CaveBot.delay(500)
      end

      if player:getOutfit().type == 1186 then
        currentOutfit.type = storage_custom.outfit
        currentOutfit.head = 1
        currentOutfit.body = 114
        currentOutfit.legs = 114
        currentOutfit.feet = 114
				currentOutfit.addons = 3
        g_game.changeOutfit(currentOutfit)
      end

      CaveBot.gotoLabel(label_to_go)
    end

    CaveBot.delay(CaveBot.Config.get("useDelay") + CaveBot.Config.get("ping"))
    return true
  end)

  CaveBot.Editor.registerAction("checktrainer", "check trainer", {
    value="label",
    title="Check trainer",
    description="Check if train or go hunt (label to go if stamina is ok)",
    multiline=false
  })
end
