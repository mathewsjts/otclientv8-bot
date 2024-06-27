local lifeRingThresholdAdd = 3   -- Quantidade mínima para adicionar Life Ring na lista de loot
local lifeRingThresholdRemove = 6  -- Quantidade mínima para remover Life Ring da lista de loot

local lootLifeRing = false  -- Variável para controlar se Life Ring está na lista de loot

macro(3000, "Manage Life Rings", function()
    local containers = getContainers()

    -- Verifica se os containers estão disponíveis
    if not containers then
        return
    end

    -- Contagem de life rings no inventário
    local lifeRingCount = 0
    for _, container in ipairs(containers) do
      for _, item in ipairs(container:getItems()) do
          if item:getId() == 3052 then  -- ID do Life Ring
              lifeRingCount = lifeRingCount + item:getCount()
          end
      end
    end

    -- Verifica o storage para decidir se adiciona ou remove Life Ring na lista de loot
    if lifeRingCount < lifeRingThresholdAdd and not lootLifeRing then
        -- Adiciona Life Ring na lista de loot
        g_game.talk("!quickloot add,life ring")
        lootLifeRing = true
    elseif lifeRingCount >= lifeRingThresholdRemove and lootLifeRing then
        -- Remove Life Ring da lista de loot
        g_game.talk("!quickloot remove,life ring")
        lootLifeRing = false
    end
end)