local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('flex-moneywash:server:setMachineState', function(machine, state)
    if state then
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.coinItem], "remove", 1)
        Player.Functions.RemoveItem(Config.coinItem, 1)
    end
    TriggerClientEvent('flex-moneywash:client:setMachineState', -1, machine, state)
end)

RegisterNetEvent('flex-moneywash:server:reward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cashamount = Config.BagAmount * Config.BagWorth
    if Player.Functions.RemoveItem(Config.BagItem, Config.BagAmount) and Player ~= nil then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.BagItem], "remove", Config.BagAmount)
        Player.Functions.AddMoney('cash', cashamount)
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.getmoney')..cashamount, 'success')
    end
end)