_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Metro", "~r~Los Santos Transit")
_menuPool:Add(mainMenu)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function CreateBlip(coords)
    local blip = AddBlipForCoord(coords)

    SetBlipSprite(blip, 78)
    SetBlipScale(blip, 0.4)
    SetBlipColour(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Metro")
    EndTextCommandSetBlipName(blip)

    return blip
end

Citizen.CreateThread(function()
    for _, BlipCoords in pairs(Config.Blips) do
        CreateBlip(BlipCoords)
    end
end)

function IsInZone()
    local coords = GetEntityCoords(PlayerPedId())
    for k, v in pairs(Config.Zones) do
        if #(coords - v.xyz) < (v.sizeX / 2) then
            return true
        end
    end
    return false
end

AllowMenu = true

function AddMenuStation(menu)
    for k, destination in ipairs(Config.Stations) do
        local newitem = NativeUI.CreateItem(destination, "Trains run every 5 mins")
        newitem:SetLeftBadge(BadgeStyle.Star) --Optional
        menu:AddItem(newitem)
    end

    menu.OnItemSelect = function(sender, item, index)
        AllowMenu = false
        Index = index
        TriggerServerEvent("TravelRequest", index)
        mainMenu:Visible(not mainMenu:Visible())
    end

    --[[menu.OnIndexChange = function(sender, index)
        if sender.Items[index] == newitem then
            newitem:SetLeftBadge(BadgeStyle.None)
        end
    end]]

    menu.OnMenuClosed = function(menu)
        AllowMenu = false
        Citizen.Wait(5000)
        AllowMenu = true
    end
end

AddMenuStation(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(Config.Zones) do
            DrawMarker(1, v.xyz[1], v.xyz[2], v.xyz[3] - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.sizeX, v.sizeY, 1.5, 255, 0, 0, 50, false, false, 2, false, nil, nil, false)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()

        if not mainMenu:Visible() and AllowMenu and IsInZone() then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)

RegisterNetEvent("TimeLeft", function(minsleft)
    local string = "You are going to ~h~" .. Config.Stations[Index] .. " Station~h~, the train will be here in less than " .. minsleft .. " minute(s)"
    ShowNotification(string)
end)

RegisterNetEvent("TrainArrival", function()
    local string = "Travelling"
    ShowNotification(string)
    Citizen.Wait(10000)
    AllowMenu = true
end)

RegisterNetEvent("StayInZone", function()
    local string = "You are no longer waiting for the train"
    ShowNotification(string)
    AllowMenu = true
end)
