local pvp = false
local Spells = {
  -- {name = "", cast = false, cooldown = 1000, amount = 1, distance = 10, buffSpell = true, manaCost = 500, level = 1, minDistance = 0, targets={}},
  -- {name = "exeta amp res", cast = true, cooldown = 3000, amount = 1, distance = 5, manaCost = 300, level = 1, minDistance = 2, targets={"Mould Phantom", "Vibrant Phantom"}},
  {name = "utori gran kor", cast = true, cooldown = 1000, amount = 0, distance = 1, manaCost = 300, level = 1, minDistance = 0, targets={}},
  {name = "exeta hur", cast = true, cooldown = 1000, amount = 0, distance = 4, manaCost = 300, level = 1, minDistance = 0, targets={}},
  -- {name = "exori gran hur", cast = true, cooldown = 1000, amount = 0, distance = 4, manaCost = 500, level = 1, minDistance = 0, targets={}},
  {name = "exori min", cast = true, cooldown = 1000, amount = 0, distance = 1, manaCost = 500, level = 1, minDistance = 0, targets={}},
  {name = "exori gran", cast = true, cooldown = 1000, amount = 3, distance = 1, manaCost = 500, level = 1, minDistance = 0, targets={}},
  --  {name = "exori gran ico", cast = true, cooldown = 2000, amount = 0, distance = 1, manaCost = 500, level = 1, minDistance = 0, targets={}},
  {name = "uber exori", cast = true, cooldown = 2000, amount = 1, distance = 1, manaCost = 6000, level = 1, minDistance = 0, targets={}},
}

local cooldowns = {}

for _, spell in ipairs (Spells) do
  cooldowns[spell.name] = now
end

macro(500, "Training Rotation", function()
    local isSafe = true;
    local target = g_game.getAttackingCreature()
    local direct
    local whitelistMonsters = {"Emberwing", "Skullfrost", "Groovebeast", "Thundergiant"}

if not g_game.isAttacking() then
    return
end

if player:getPosition().z == target:getPosition().z then
    if  player:getPosition().x > target:getPosition().x then direct = 3 -- west
    elseif  player:getPosition().x < target:getPosition().x then direct = 1 -- east
    elseif player:getPosition().y > target:getPosition().y then direct = 0 -- north
    elseif  player:getPosition().y < target:getPosition().y then direct = 2 -- south
    end
end

for _, spell in ipairs(Spells) do
    local specAmount = 0
    for i,mob in ipairs(getSpectators()) do
        local distance = getDistanceBetween(player:getPosition(), mob:getPosition())
        if (distance >= spell.minDistance and distance <= spell.distance and mob:isMonster()) and (#spell.targets == 0 or table.find(spell.targets, mob:getName()))  then
            if table.find(whitelistMonsters, mob:getName()) then
                specAmount = specAmount
            else
                specAmount = specAmount + 1
            end
        end
        if (mob:isPlayer() and player:getName() ~= mob:getName()) then
            isSafe = false;
        end
    end

    if (spell.cast) and cooldowns[spell.name] < now and canCast(spell.name) and (specAmount >= spell.amount) and (mana() >= spell.manaCost) and (lvl() >= spell.level) then
        if not spell.buffSpell or not hasPartyBuff() then
            if pvp then
                if isSafe then
                    if player:getDirection() ~= direct and (getDistanceBetween(player:getPosition(), target:getPosition())  <= spell.distance) and spell.turning then
                        turn(direct)
                    end
                    say(spell.name)
                    cooldowns[spell.name] = now + spell.cooldown
             elseif not isSafe and spell.safe then
                    say(spell.name)
                    cooldowns[spell.name] = now + spell.cooldown
                end
            else
                if player:getDirection() ~= direct and (getDistanceBetween(player:getPosition(), target:getPosition())  <= spell.distance) and spell.turning then
                    turn(direct)
                end
                say(spell.name)
                cooldowns[spell.name] = now + spell.cooldown
            end
        end
    end
end

end)
