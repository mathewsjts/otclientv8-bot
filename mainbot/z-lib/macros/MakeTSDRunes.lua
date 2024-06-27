local tsdRuneId = 3160  -- ID da Thunderstorm Rune (ajuste conforme necessário)
local makingTsd = false  -- Variável para controlar se estamos fazendo runas

macro(1000, "Make TSD Runes", function()
    local player = g_game.getLocalPlayer()

    -- Verifica se o jogador está conectado
    if not player then
        return
    end

    -- Obtém a quantidade atual de runas TSD no inventário
    local tsdCount = 0
    local containers = getContainers()

    for _, container in ipairs(containers) do
        for _, item in ipairs(container:getItems()) do
            if item:getId() == tsdRuneId then  -- ID da TSD Rune
                tsdCount = tsdCount + item:getCount()
            end
        end
    end

    -- Verifica se há menos de 100 runas TSD e se não estamos fazendo runas
    if tsdCount < 100 and not makingTsd then
        -- Começa a fazer runas TSD
        cast("adori mas vis")
        makingTsd = true

    -- Verifica se há mais de 400 runas TSD e se estamos fazendo runas
    elseif tsdCount >= 400 and makingTsd then
        -- Para de fazer runas TSD
        makingTsd = false
    end
end)