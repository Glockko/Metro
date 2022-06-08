RegisterNetEvent("TravelRequest", function(index)
    local _source = source
    local _index  = index

    local time = GetTime()
    local minsleft = 5 - (time.m % 5)
    local isWaiting = true
    local cancel = false

    TriggerClientEvent("TimeLeft", _source, minsleft)

    Citizen.CreateThread(function()
        while IsInZone(_source) do
            Citizen.Wait(4000)
            if not isWaiting then
                break
            end
        end
        if isWaiting then
            TriggerClientEvent("StayInZone", _source)
            cancel = true
        end
    end)

    --Citizen.Wait((minsleft - 1) * 60000 + (60 - time.s) * 1000)
    Citizen.Wait(10000)

    if cancel then
        return
    end
    TriggerClientEvent("TrainArrival", _source)
    SetEntityCoords(_source, (Config.Zones[_index].xyz + vector3(0, 2.5, 0)), false, false, false, false)
    isWaiting = false

end)

function GetTime()
    local timestamp = os.time()
    local m = tonumber(os.date('%M', timestamp))
    local s = tonumber(os.date('%S', timestamp))
    return { m = m, s = s }
end

function IsInZone(_source)
    local coords = GetEntityCoords(GetPlayerPed(_source))
    for k, v in pairs(Config.Zones) do
        if #(coords - v.xyz) < (v.sizeX / 2) then
            return true
        end
    end
    return false
end
