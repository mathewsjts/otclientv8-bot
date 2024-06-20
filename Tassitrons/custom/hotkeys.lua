
local currentOutfit = 0

-- Say outfit
hotkey('Ctrl+Shift+o', function()
  info(player:getOutfit().type)
end)

-- Say mount
hotkey('Shift+m', function()
  info(player:getOutfit().mount)
end)

-- Dash w Start MW
hotkey('Home', function()
  if (canCast("adana grav") and canCast("exori flam")) then
    saySpell("adana grav")
    useWith(3180, g_map.getTile(pos()):getTopUseThing())
  end
end)

local slideLimits = {
  [0] = { x =  0, y = -4 },
  [1] = { x =  4, y =  0 },
  [2] = { x =  0, y =  4 },
  [3] = { x = -4, y =  0 },
}

function sum2DVec(v1, v2)
  return { x = v1.x + v2.x, y = v1.y + v2.y, z = v1.z }
end

-- Dash w End MW
hotkey('End', function()
  if (canCast("adana grav") and canCast("exori flam")) then
    local dir = player:getDirection()

    saySpell("adana grav")
    useWith(3180, g_map.getTile(sum2DVec(pos(), slideLimits[dir])):getTopUseThing())
  end
end)

-- cooldowns
hotkey('Ctrl+Shift+c', function()
  local ids = ''
  for k, v in pairs(modules.game_cooldown.cooldown) do
    if v then
      ids = ids .. k .. ' '
    end
  end

  say(ids)
end)
