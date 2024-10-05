if NMConfig['Framework'] == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif NMConfig['Framework'] == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()
end

RegisterServerEvent('updateTrigger', function()
    local src = source
    if NMConfig['Framework'] == 'qb' then
        local playerData = QBCore.Functions.GetPlayer(src)
        local firstName = playerData.PlayerData.charinfo.firstname
        local lastName = playerData.PlayerData.charinfo.lastname
        local totalName = firstName .. ' ' .. lastName
        TriggerClientEvent('updateTriggerClient', -1, source, totalName)
    elseif NMConfig['Framework'] == 'esx' then
        local playerData = ESX.GetPlayerFromId(src)
        local totalName = playerData.getName()
        TriggerClientEvent('updateTriggerClient', -1, source, totalName)
    end
end)

RegisterServerEvent('removeTrigger', function()
    TriggerClientEvent('removeTriggerClient', -1, source)
end)

-- open this feature if you're using esx

-- RegisterCommand('loginadmintype', function(source, args, rawCommand)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
--         TriggerClientEvent('loginadmintypeclient', source)
--     end
-- end)

QBCore.Commands.Add('loginadmintype', '', arguments, argsRequired, function(source)
    TriggerClientEvent('loginadmintypeclient', source)
end, 'admin')