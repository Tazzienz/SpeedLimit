local QBCore = exports['qb-core']:GetCoreObject()
local speedLimit = nil

RegisterNetEvent('qb-speedlimit:setSpeedLimit', function(speed)
    speedLimit = speed
end)

RegisterNetEvent('qb-speedlimit:enforceSpeedLimit', function(speed)
    speedLimit = speed
end)

CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerPedId()
        if IsPedInAnyVehicle(player, false) then
            local vehicle = GetVehiclePedIsIn(player, false)
            if GetPedInVehicleSeat(vehicle, -1) == player and speedLimit then
                local speed = GetEntitySpeed(vehicle) * 3.6 -- Convert to km/h
                if speed > speedLimit then
                    local newSpeed = speedLimit / 3.6 -- Convert back to m/s
                    SetVehicleForwardSpeed(vehicle, newSpeed)
                end
            end
        end
    end
end)