ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterCommand('mesaigir', function()
    local player = PlayerPedId()
    local job = ESX.PlayerData.job.name

    if job == 'police' or job == 'ambulance' or job == 'sheriff' then
        exports['mythic_notify']:SendAlert('error', 'Zaten mesaidesin!', 3000)
        return
    end

    if job == 'offpolice' or job == 'offambulance' or job == 'offsheriff' then
        local playercoords = GetEntityCoords(player)
        local job = string.sub(job, 4)
        local jobcoords = Config[job].coords
        local distance = #(playercoords - jobcoords)

        if distance < Config.radius then
            TriggerServerEvent('m3:duty:server:dutyOn')
        else
            exports['mythic_notify']:SendAlert('error', 'Burası mesaiye girmek için uygun değil!', 3000)
        end
    end
end)

RegisterCommand('mesaicik', function()
    local player = PlayerPedId()
    local job = ESX.PlayerData.job.name

    if job == 'offpolice' or job == 'offambulance' or job == 'offsheriff' then
        exports['mythic_notify']:SendAlert('error', 'Zaten mesaide değilsin!', 3000)
        return
    end

    if job == 'police' or job == 'ambulance' or job == 'sheriff' then
        local playercoords = GetEntityCoords(player)
        local jobcoords = Config[job].coords
        local distance = #(playercoords - jobcoords)

        if distance < Config.radius then
            TriggerServerEvent('m3:duty:server:dutyOff')
        else
            exports['mythic_notify']:SendAlert('error', 'Burası mesaiden çıkmak için uygun değil!', 3000)
        end
    end
end)