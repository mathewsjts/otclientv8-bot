local paralyzeRuneId = 3165
local manaPercent = 60
fastermana = macro(100,  function()
  if (target() and target():getPosition().z == posz() and target():getSpeed() > 500 and not target():isNpc() and manapercent() >= manaPercent) then
    usewith(paralyzeRuneId, target())
  end
end)

addIcon("Paralyze", {item = paralyzeRuneId, text = "Paralze"}, function(icon, isOn)
  fastermana.setOn(isOn)
end)
