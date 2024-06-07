local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("repairkit", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	TriggerClientEvent("RageRepairSystem:client:useRepairKit", source, 'repairkit')
end)

QBCore.Functions.CreateUseableItem("advancedrepairkit", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	TriggerClientEvent("RageRepairSystem:client:useRepairKit", source, 'advancedrepairkit')
end)

QBCore.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	TriggerClientEvent("RageRepairSystem:client:useCleaningKit", source)
end)

RegisterNetEvent('RageRepairSystem:server:RemoveItem', function(item)
    local Player = QBCore.Functions.GetPlayer(source)
    if item == 'repairkit' then
        Player.Functions.RemoveItem("repairkit", 1)
    elseif item == 'advancedrepairkit' then
        Player.Functions.RemoveItem("advancedrepairkit", 1)
    elseif item == 'cleaningkit' then
        Player.Functions.RemoveItem("cleaningkit", 1)
    end
end)