-- IDs das armas (ajuste conforme necessário)
local initialWeaponId = 3282  -- ID da arma inicial
local secondaryWeaponId = 3283  -- ID da segunda arma

macro(250, "Troca de Armas", function()
    local player = g_game.getLocalPlayer()

    -- Verifica se o jogador está conectado
    if not player then
        return
    end

    -- Obtém o alvo atual
    local target = player:getTarget()

    -- Verifica se há um alvo
    if not target then
        return
    end

    -- Verifica se o alvo é uma criatura (monstro)
    if not target:isMonster() then
        return
    end

    -- Obtém a porcentagem de HP do alvo
    local targetHpPercent = target:getHealthPercent()

    -- Troca de armas com base na porcentagem de HP do alvo
    if targetHpPercent <= 5 then
        -- Troca para a segunda arma se o HP do alvo estiver abaixo de 5%
        if player:getInventoryItem(GAME_WEAPON_SLOT).getId() ~= secondaryWeaponId then
            g_game.equipItem(player:getInventoryItem(GAME_BACKPACK).getItem(secondaryWeaponId), GAME_WEAPON_SLOT)
        end
    else
        -- Troca para a arma inicial se o HP do alvo estiver acima de 5%
        if player:getInventoryItem(GAME_WEAPON_SLOT).getId() ~= initialWeaponId then
            g_game.equipItem(player:getInventoryItem(GAME_BACKPACK).getItem(initialWeaponId), GAME_WEAPON_SLOT)
        end
    end
end)