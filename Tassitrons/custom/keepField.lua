local currentPos = pos()
local myRight = pos()

local largerFireId = 21465


local checkSides = macro(500, function()
  local myRight = pos()
  myRight.x = myRight.x + 1

  local myLeft = pos()
  myLeft.x = myLeft.x - 1

  local myTop = pos()
  myTop.y = myTop.y - 1

  local myBottom = pos()
  myBottom.y = myTop.y + 1

  local tile = g_map.getTile(pos())
  for i, item in ipairs(tile:getItems()) do
    if item:getId() ~= largerFireId then
      return
    else
      -- renove field
    end
  end

end)
