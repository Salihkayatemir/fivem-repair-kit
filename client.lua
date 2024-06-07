local QBCore = exports['qb-core']:GetCoreObject()

-- Normal repair kit 
RegisterNetEvent('RageRepairSystem:client:useRepairKit', function(repairKitType)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(playerPos.x, playerPos.y, playerPos.z, 5.0, 0, 71)

    if vehicle ~= 0 then
        local frontPos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 2.5, 0.0) -- Position in front of the vehicle
        local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, frontPos.x, frontPos.y, frontPos.z)

        if distance < 2.0 then
            -- open the hood
            SetVehicleDoorOpen(vehicle, 4, false, false)
            -- Start repair animation and progress bar
            QBCore.Functions.Progressbar("tamir", "Tamir ediliyor...", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mini@repair",
                anim = "fixing_a_ped",
                flags = 49,
            }, {}, {}, function() -- Done
                StopAnimTask(playerPed, "mini@repair", "fixing_a_ped", 1.0)
                -- close the hood
                SetVehicleDoorShut(vehicle, 4, false)
                -- Normal repair: Repairs engine damage only
                SetVehicleEngineHealth(vehicle, 1000.0)
                QBCore.Functions.Notify('Motor hasarı tamir edildi.','success')
                -- Remove used item from inventory,
                if repairKitType == 'repairkit' then -- Normal Repair Kit
                    SetVehicleEngineHealth(vehicle, 1000.0)
                    TriggerServerEvent('RageRepairSystem:server:RemoveItem', 'repairkit')
                elseif repairKitType == 'advancedrepairkit' then -- Advanced Repair Kit
                    SetVehicleFixed(vehicle)
                    TriggerServerEvent('RageRepairSystem:server:RemoveItem', 'advancedrepairkit')
                end
            end, function() -- Cancel
                StopAnimTask(playerPed, "mini@repair", "fixing_a_ped", 1.0)
                QBCore.Functions.Notify("Tamir işlemi iptal edildi.", "error")
            end)
        else
            QBCore.Functions.Notify('Aracın önünde olmalısınız.','error')
        end

    else
        QBCore.Functions.Notify('Yakınınızda tamir edilecek araç yok.','error')
    end
end)

RegisterNetEvent('RageRepairSystem:client:useCleaningKit', function()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(playerPos.x, playerPos.y, playerPos.z, 5.0, 0, 71)
    print(GetVehicleDirtLevel(vehicle))

    if vehicle ~= 0 then
        QBCore.Functions.Progressbar("temizleme", "Araç Temizleniyor...", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@world_human_maid_clean@",
            anim = "base",
            flags = 49,
        }, {}, {}, function() -- Done
            print(GetVehicleDirtLevel(vehicle))
            StopAnimTask(playerPed, "amb@world_human_maid_clean@", "base", 1.0)
            SetVehicleDirtLevel(vehicle, 0.0)
            WashDecalsFromVehicle(vehicle, 1000.0)
            TriggerServerEvent('RageRepairSystem:server:RemoveItem', 'cleaningkit')
            QBCore.Functions.Notify('Temizleme işlemi tamamlandı','success')
            print(GetVehicleDirtLevel(vehicle))

        end, function() -- Cancel
            StopAnimTask(playerPed, "amb@world_human_maid_clean@", "base", 1.0)
            QBCore.Functions.Notify("Temizleme işlemi iptal edildi.", "error")
        end)
    else
        QBCore.Functions.Notify('Yakınınızda temizlenecek araç yok.','error')
    end
end)