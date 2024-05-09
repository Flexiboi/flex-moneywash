local QBCore = exports['qb-core']:GetCoreObject()
local entered, machineid, hasmachine, startwash, iswashing = false, 0, false, false, false
local totaltTimer, washtimer = Config.TotalWashTime, 0
local enteredlocation = 1
local EnterZones = {}

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function enterAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(GetPlayerPed(-1))
end

function washAnim()
    loadAnimDict("mp_car_bomb") 
    TaskPlayAnim( GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(750)
    ClearPedTasks(GetPlayerPed(-1))
end

function teleport(ped, x, y, z, w)
    CreateThread(function()
        SetEntityCoords(ped, x, y, z, 0, 0, 0, false)
        SetEntityHeading(ped, w)
        Wait(100)
        DoScreenFadeIn(1000)
    end)
end

function displaytime(seconds)
    local seconds = tonumber(seconds)
  
    if seconds <= 0 then
      return "00:00:00";
    else
      hours = string.format("%02.f", math.floor(seconds/3600));
      mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
      secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
      return hours..":"..mins..":"..secs
    end
end

function startwashingmachine()
    CreateThread(function()
        while hasmachine do
            totaltTimer = totaltTimer - 1
            if totaltTimer <= 0 then
                TriggerServerEvent('flex-moneywash:server:setMachineState', machineid, false)
                machineid, hasmachine, startwash, iswashing = 0, false, false, false
                totaltTimer, washtimer = Config.TotalWashTime, 0
            end
            Citizen.Wait(1000)
            if not hasmachine then
                break
            end
        end
    end)
end

function washing()
    CreateThread(function()
        while startwash do
            washtimer = washtimer - 1
            if washtimer <= 0 then
                startwash = false
                if entered then
                    TriggerServerEvent('flex-moneywash:server:reward')
                end
            end
            Citizen.Wait(1000)
            if not startwash then
                break
            end
        end
    end)
end

CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local leaveloc = #(Config.tp.leave - pos)
        if leaveloc < 3 then
            QBCore.Functions.DrawText3D(Config.tp.leave.x, Config.tp.leave.y, Config.tp.leave.z, '[~o~E~w~]'..Lang:t("info.leaveloc"))
            if IsControlJustReleased(0, 38) then
                enterAnim()
                teleport(ped, Config.tp.enter[enteredlocation].x, Config.tp.enter[enteredlocation].y, Config.tp.enter[enteredlocation].z, 0)
                entered = false
            end
        end
    end
end)

for k, loc in pairs(Config.tp.enter) do

    EnterZones[k] = BoxZone:Create(loc, 3.0, 3.0, {
        name = 'enterzone'..k,
        useZ = true,
        debugPoly = Config.Debug
    })

    EnterZones[k]:onPlayerInOut(function(isPointInside, point)
        isInEnterZone = isPointInside
        if isPointInside then
            exports['qb-core']:DrawText('[E] '..Lang:t("info.leaveloc"), 'left')
            CreateThread(function()
                while isInEnterZone do
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    if IsControlJustReleased(0, 38) then
                        exports['qb-core']:KeyPressed()
                        exports['qb-core']:HideText()
                        enteredlocation = k
                        enterAnim()
                        teleport(ped, Config.tp.leave.x, Config.tp.leave.y, Config.tp.leave.z+0.5, 0)
                        enter()
                        break
                    end
                    Wait(0)
                end
            end)
        else
            exports['qb-core']:HideText()
        end
    end)
end

function enter()
    entered = true
    CreateThread(function()
        while true do
            Citizen.Wait(1)
            if entered then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                for k, v in pairs(Config.washLocations) do
                    local distance = #(v.loc - pos)
                    if distance < 3 then
                        if not v.bussy then
                            QBCore.Functions.DrawText3D(v.loc.x, v.loc.y, v.loc.z+0.1, Lang:t("info.free"))
                            QBCore.Functions.DrawText3D(v.loc.x, v.loc.y, v.loc.z+0.2, '[~o~E~w~]'..Lang:t("info.addcoin"))
                        else
                            QBCore.Functions.DrawText3D(v.loc.x, v.loc.y, v.loc.z+0.4, Lang:t("info.totalwashtimer")..displaytime(totaltTimer))
                            QBCore.Functions.DrawText3D(v.loc.x, v.loc.y, v.loc.z+0.3, Lang:t("info.washtimer")..displaytime(washtimer))
                            QBCore.Functions.DrawText3D(v.loc.x, v.loc.y, v.loc.z+0.1, Lang:t("info.bussy"))
                        end
                        if hasmachine and machineid == k then
                            if not startwash then
                                QBCore.Functions.DrawText3D(v.loc.x, v.loc.y, v.loc.z+0.2, '[~o~E~w~]'..Lang:t("info.startwash"))
                            elseif startwash then
                            end
                        end
                        if distance < 1 then
                            if IsControlJustReleased(0, 38) then
                                if not v.bussy then
                                    if not hasmachine then
                                        if QBCore.Functions.HasItem(Config.coinItem, 1) then
                                            machineid = k
                                            TriggerServerEvent('flex-moneywash:server:setMachineState', k, true)
                                            QBCore.Functions.Notify(Lang:t("success.startedmachine"), "success", 5000)
                                            hasmachine = true
                                            startwashingmachine()
                                        else
                                           QBCore.Functions.Notify(Lang:t("error.nocoin"), "error", 5000)
                                        end
                                    else
                                        QBCore.Functions.Notify(Lang:t("error.alreadymachine"), "error", 5000)
                                    end
                                elseif hasmachine then
                                    if not startwash then
                                        if QBCore.Functions.HasItem(Config.BagItem, Config.BagAmount) then
                                            QBCore.Functions.Notify(Lang:t("success.startwash"), "success", 5000)
                                            startwash = true
                                            washtimer = (Config.TotalWashTime/Config.MaxWashPerCoint)
                                            washing()
                                            washAnim()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                break
            end
        end
    end)
end

RegisterNetEvent('flex-moneywash:client:setMachineState', function(machine, state)
    Config.washLocations[machine].bussy = state
end)
