TaskBot.taskList = {
  "Crocodiles", "Gnarlhounds",
  "Terramites",
  "Tarantulas",
  "Apes", "Wailing Widows", "Lancer Beetles",
  -- "Lancer Beetles", "Wailing Widows", "Mutated Rats",
  -- "Quara Scouts", "Wyverns", "Ice Golems", "Crystal Spiders",
  -- "Nightmares", "High Class Lizards", "Giant Spiders"
}

TaskBot.taskRequirements = {
  Crocodiles = {
    minLevel = 0, maxLevel = 49,
    tools = { "rope", "shovel" },
    supply = {},
    skills = {},
    equipments = {
      atk = 0, def = 0, arm = 0,
      protection = {}
    }
  },
  Gnarlhounds = {
    minLevel = 0, maxLevel = 49,
    tools = { "rope", "shovel" },
    supply = {},
    skills = {},
    equipments = {
      atk = 0, def = 0, arm = 0,
      protection = {}
    }
  },
  Terramites = {
    minLevel = 0, maxLevel = 49,
    tools = { "rope", "shovel" },
    supply = {},
    skills = {},
    equipments = {
      atk = 0, def = 0, arm = 0,
      protection = {}
    }
  },
  Tarantulas = {
    minLevel = 0, maxLevel = 49,
    tools = { "rope", "shovel" },
    supply = {},
    skills = {},
    equipments = {
      atk = 0, def = 0, arm = 0,
      protection = {}
    }
  },
  Apes = {
    minLevel = 0, maxLevel = 49,
    tools = { "rope", "shovel" },
    supply = {
      healthPotion = { type = 266, min = 10, max = 100 },
    },
    skills = { physical = 40 },
    equipments = {
      atk = 0, def = 0, arm = 0,
      protection = {}
    }
  },
  LancerBeetles = {
    minLevel = 50, maxLevel = 79,
    tools = { "rope", "shovel" },
    supply = {
      healthPotion = { type = 266, min = 10, max = 100 },
      manaPotion = { min = 30, max = 500 }
    },
    skills = { },
    equipments = {
      atk = 0, def = 0, arm = 0,
      protection = {}
    }
  },
  WailingWidows = {
    minLevel = 50, maxLevel = 79,
    tools = { "rope", "shovel" },
    supply = {},
    skills = {},
    equipments = {
      atk = 0, def = 0, arm = 0,
      protection = {}
    }
  },
  MutatedRats = {
    minLevel = 0, maxLevel = 49,
    tools = { "rope", "shovel" },
    supply = {},
    skills = {},
    equipments = {
      atk = 0, def = 0, arm = 0,
      protection = {}
    }
  },
}
