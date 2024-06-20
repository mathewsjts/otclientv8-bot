BattleSystem = {}
BattleSystem.onConcludeAction = function() end
BattleSystem.onFail = function() end
BattleSystem.setDelay = function() end

local target = nil
local battleMacro = {}

battleMacro = macro(100, function()
  if not target then
    battleMacro.setOn(false)
  end

  local currentTarget = g_game.getAttackingCreature()

  if not currentTarget or currentTarget:getId() ~= target then
    for _, spec in ipairs(getSpectators()) do
      if spec:getId() == target then
        g_game.attack(spec)
      end
    end
  end
end)
battleMacro.setOn(false)

BattleSystem.attack = function(creatureId)
  target = creatureId
  if not battleMacro.isOn() then
    battleMacro.setOn(true)
  end
  info("Attack creature: " .. creatureId)
  BattleSystem.onConcludeAction()
end

BattleSystem.stopAttack = function()
  target = nil

  if battleMacro.isOn() then
    battleMacro.setOn(false)
  end

  local currentTarget = g_game.getAttackingCreature()

  if currentTarget then
    g_game.cancelAttack()
  end

  BattleSystem.onConcludeAction()
end



