local QBCore = exports['qb-core']:GetCoreObject()
local speedLimits = {}

QBCore.Commands.Add("setspeedlimit", "Set a speed limit for your current vehicle", {{name="speed", help="Speed limit in km/h"}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local speed = tonumber(args[1])

    if not speed or speed < 0 then
        TriggerClientEvent('QBCore:Notify', src, "Please enter a valid speed limit in km/h", "error")
        return
    end

    TriggerClientEvent("qb-speedlimit:setSpeedLimit", src, speed)
end)

RegisterNetEvent('qb-speedlimit:setSpeedLimit', function(speed)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    speedLimits[Player.PlayerData.citizenid] = speed
    TriggerClientEvent('QBCore:Notify', src, "Speed limit set to " .. speed .. " km/h", "success")
end)

CreateThread(function()
    while true do
        Wait(1000)
        for _, player in ipairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(player)
            if Player then
                local citizenid = Player.PlayerData.citizenid
                if speedLimits[citizenid] then
                    TriggerClientEvent('qb-speedlimit:enforceSpeedLimit', player, speedLimits[citizenid])
                end
            end
        end
    end
end)