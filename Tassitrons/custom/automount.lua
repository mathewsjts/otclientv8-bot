local isOn = false

onStatesChange(function(localPlayer, states, oldStates)
  if not isOn then return end

  local bitsChanged = bit32.bxor(states, oldStates)
  for i = 1, 32 do
    local pow = math.pow(2, i-1)
    if pow > bitsChanged then break end
    local bitChanged = bit32.band(bitsChanged, pow)
    if bitChanged == 16384 and not isInPz() then
      localPlayer:mount()
    end
  end
end)

local ui = UI.createWidget('BotSwitch')
ui:setText("Teste")
ui:setOn(isOn)

ui.onClick = function(widget)
  if widget:isOn() then
    isOn = false
    widget:setOn(false)
  else
    isOn = true
    widget:setOn(true)
  end
end
