local SLCore = exports['sl-core']:GetCoreObject()
local HasKeys = {}
local IsHotwiring = false

-- Key Functions
local function HasVehicleKey(plate)
    return HasKeys[plate] or false
end

local function AddVehicleKey(plate)
    HasKeys[plate] = true
    TriggerServerEvent('sl-vehicles:server:SaveVehicleKey', plate)
end

local function RemoveVehicleKey(plate)
    HasKeys[plate] = nil
    TriggerServerEvent('sl-vehicles:server:RemoveVehicleKey', plate)
end

-- Vehicle Lock Functions
local function LockVehicle(vehicle)
    local ped = PlayerPedId()
    local plate = GetVehicleNumberPlateText(vehicle)
    
    if HasVehicleKey(plate) then
        local lockStatus = GetVehicleDoorLockStatus(vehicle)
        if lockStatus == 1 then -- unlocked
            SetVehicleDoorsLocked(vehicle, 2)
            PlayVehicleDoorCloseSound(vehicle, 1)
            SLCore.Functions.Notify("Vehicle locked!", "success")
        else
            SetVehicleDoorsLocked(vehicle, 1)
            PlayVehicleDoorOpenSound(vehicle, 0)
            SLCore.Functions.Notify("Vehicle unlocked!", "success")
        end
        
        SetVehicleLights(vehicle, 2)
        Wait(250)
        SetVehicleLights(vehicle, 0)
    else
        SLCore.Functions.Notify("You don't have the keys!", "error")
    end
end

-- Hotwire Functions
local function StartHotwire(vehicle)
    local ped = PlayerPedId()
    local plate = GetVehicleNumberPlateText(vehicle)
    
    if not IsHotwiring then
        IsHotwiring = true
        SetVehicleAlarm(vehicle, true)
        StartVehicleAlarm(vehicle)
        
        SLCore.Functions.Progressbar("hotwiring_vehicle", "Hotwiring Vehicle...", Config.HotwireTime * 1000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            IsHotwiring = false
            
            local success = math.random(1, 100) <= 50
            if success then
                AddVehicleKey(plate)
                SetVehicleDoorsLocked(vehicle, 1)
                SetVehicleEngineOn(vehicle, true, false, true)
                SLCore.Functions.Notify("Hotwire successful!", "success")
            else
                SLCore.Functions.Notify("Hotwire failed!", "error")
            end
            
            SetVehicleAlarm(vehicle, false)
        end)
    end
end

-- Events
RegisterNetEvent('sl-vehicles:client:GiveKeys', function(plate)
    AddVehicleKey(plate)
    SLCore.Functions.Notify("Received keys for vehicle: " .. plate, "success")
end)

RegisterNetEvent('sl-vehicles:client:RemoveKeys', function(plate)
    RemoveVehicleKey(plate)
    SLCore.Functions.Notify("Lost keys for vehicle: " .. plate, "error")
end)

-- Key Bindings
RegisterCommand('togglelock', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    
    if vehicle ~= 0 then
        LockVehicle(vehicle)
    end
end)

RegisterKeyMapping('togglelock', 'Toggle Vehicle Lock', 'keyboard', 'L')

-- Vehicle Entry
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        
        if IsPedGettingIntoAVehicle(ped) then
            local vehicle = GetVehiclePedIsTryingToEnter(ped)
            local plate = GetVehicleNumberPlateText(vehicle)
            
            if Config.UseKeys and not HasVehicleKey(plate) then
                if GetPedInVehicleSeat(vehicle, -1) == 0 then
                    SetVehicleDoorsLocked(vehicle, 2)
                    
                    -- Allow hotwiring from driver's seat
                    CreateThread(function()
                        while true do
                            Wait(0)
                            if IsPedInVehicle(ped, vehicle, false) then
                                if IsControlJustPressed(0, 47) then -- G key
                                    StartHotwire(vehicle)
                                    break
                                end
                            else
                                break
                            end
                        end
                    end)
                end
            end
        end
    end
end)

-- Exports
exports('HasVehicleKey', HasVehicleKey)
exports('AddVehicleKey', AddVehicleKey)
exports('RemoveVehicleKey', RemoveVehicleKey) 