TaskBot.loaded = false
TaskBot.tasksInProgress = {}
TaskBot.tasksCompleted = {}
TaskBot.taskProgress = {}
TaskBot.currentTask = nil

if not storage["playerStatus"] then
  storage["playerStatus"] = {}
end

if not storage["playerStatus"][player:getName()] then
  storage["playerStatus"][player:getName()] = {
    quests = {},
    tasks = {}
  }
end

if not TaskBot.loaded then
  local playerTasks = storage["playerStatus"][player:getName()]["tasks"]

  for key, value in pairs(playerTasks) do
    if value["hunted"] >= value["total"] then
      table.insert(TaskBot.tasksCompleted, key)
    end
  end

  TaskBot.loaded = true
end

