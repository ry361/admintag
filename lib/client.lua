if NMConfig['Framework'] == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif NMConfig['Framework'] == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()
end

local activeIDs = {}
local activeIDsName = {}
local baglandi = false

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local players = GetNeareastPlayers()
        for i = 1, #players do 
            for yyy = #activeIDs, 1, -1 do
                if activeIDs[yyy] == players[i].playerId then
                    sleep = 5
                    local x, y, z = table.unpack(players[i].coords)
                    Draw3DText(x, y, z + 1.30, ' ~r~ Administrator', 1.0)
                    Draw3DText(x, y, z + 1.20, '~r~'.. activeIDsName[players[i].playerId], 1.0)
                    Draw3DText(x, y, z + 1.10, '~r~ ID: '.. players[i].playerId, 1.0)
                    SetEntityAlpha(GetPlayerPed(GetPlayerFromServerId(players[i].playerId)), 150, false)
                end
            end
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('loginadmintypeclient', function()
    if not baglandi then
        TriggerServerEvent('updateTrigger')
        baglandi = true
    else
        TriggerServerEvent('removeTrigger')
        baglandi = false
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if baglandi then
            SetEntityHealth(PlayerPedId(), 200)
            SetEntityInvincible(PlayerPedId(), true)
        else
            SetEntityInvincible(PlayerPedId(), false)
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('updateTriggerClient', function(data, name)
    if not activeIDs[data] then
        table.insert(activeIDs, data)
        activeIDsName[data] = name
    else
        print('already in')
    end 
end)

RegisterNetEvent('removeTriggerClient', function(playerId)
    for i = #activeIDs, 1, -1 do
        if activeIDs[i] == playerId then
            table.remove(activeIDs, i)
            table.remove(activeIDsName, i)
            SetEntityAlpha(GetPlayerPed(GetPlayerFromServerId(playerId)), 255, false)
            break
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    SetEntityAlpha(PlayerPedId(), 255, false)
end)

function Draw3DText(x, y, z, text, newScale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local dist = GetDistanceBetweenCoords(GetGameplayCamCoords(), x, y, z, 1)
        local scale = newScale * (1 / dist) * (1 / GetGameplayCamFov()) * 100
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEdge(4, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function GetNeareastPlayers()
    local playerPed = PlayerPedId()
    local players_clean = {}
    local playerCoords = GetEntityCoords(playerPed)
    local players, _ = GetPlayersInArea(playerCoords, 25)
    for i = 1, #players, 1 do
        local playerServerId = GetPlayerServerId(players[i])
        local player = GetPlayerFromServerId(playerServerId)
        local ped = GetPlayerPed(player)
        if IsEntityVisible(ped) then
            table.insert(players_clean, {playerId = playerServerId, coords = GetEntityCoords(ped)})
        end
    end
   
    return players_clean
end

function GetPlayersInArea(coords, area)
	local players, playersInArea = GetPlayers(), {}
	local coords = vector3(coords.x, coords.y, coords.z)
	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)

		if #(coords - targetCoords) <= area then
			table.insert(playersInArea, players[i])
		end
	end
	return playersInArea
end

function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end