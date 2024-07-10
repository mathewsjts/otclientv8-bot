CaveBot.Extensions.SetBot = {}

CaveBot.Extensions.SetBot.setup = function()
  CaveBot.registerAction("SetBot", "#ffffff", function(value)
    local data = string.split(value, ",")
    local bot = data[1]:trim()
    local active = data[2]:trim()

    local actions = {
      cave = {
        on = function() CaveBot.setOn() end,
        off = function() CaveBot.setOff() end
      },
      target = {
        on = function() TargetBot.setOn() end,
        off = function() TargetBot.setOff() end
      },
    }

    actions[bot][active]()
    return true
  end)

  CaveBot.Editor.registerAction("setbot", "set bot", {
    value="target, on",
    title="Set CaveBot and TargetBot on/off",
    description="target/cave, on/off",
    multiline=false
  })
end
