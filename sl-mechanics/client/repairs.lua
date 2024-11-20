local SLCore = exports['sl-core']:GetCoreObject()
local isRepairing = false
local currentVehicle = nil
local currentLift = nil
local liftRaised = false

local function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function PlayRepairAnim()
    local ped = PlayerPedId()
    LoadAnimDict('mini@repair')
    TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 8.0, -8.0, -1, 1, 0, false, false, false)
end

local function StopRepairAnim()
    ClearPedTasks(PlayerPedId())
end

local function GetVehicleInFront()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)
    local position = coords + (forward * 2.0)
    
    local vehicle = GetClosestVehicle(position.x, position.y, position.z, 3.0, 0, 71)
    if DoesEntityExist(vehicle) then
        return vehicle
    end
    return nil
end

local function RepairVehicle(vehicle, type, part)
    if isRepairing then return end
    if not DoesEntityExist(vehicle) then return end
    
    isRepairing = true
    currentVehicle = vehicle
    
    -- Check if player has required items
    SLCore.Functions.TriggerCallback('sl-mechanics:server:HasRequiredItems', function(hasItems)
        if not hasItems then
            SLCore.Functions.Notify(Lang:t('error.no_tools'), 'error')
            isRepairing = false
            return
        end
        
        PlayRepairAnim()
        
        local time = type == 'full' and 20000 or 10000
        local progress = {
            name = 'repair_vehicle',
            duration = time,
            label = Lang:t('info.repair_progress', {progress = 0}),
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = 'mini@repair',
                anim = 'fixing_a_ped',
            }
        }
        
        if SLCore.Functions.Progressbar(progress) then
            if type == 'full' then
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                SLCore.Functions.Notify(Lang:t('success.vehicle_repaired'), 'success')
            elseif type == 'engine' then
                SetVehicleEngineHealth(vehicle, 1000.0)
                SLCore.Functions.Notify(Lang:t('success.part_replaced', {part = Lang:t('parts.engine')}), 'success')
            elseif type == 'body' then
                SetVehicleBodyHealth(vehicle, 1000.0)
                SLCore.Functions.Notify(Lang:t('success.part_replaced', {part = Lang:t('parts.body_panel')}), 'success')
            elseif type == 'part' and part then
                -- Handle specific part repairs
                TriggerServerEvent('sl-mechanics:server:RepairPart', NetworkGetNetworkIdFromEntity(vehicle), part)
                SLCore.Functions.Notify(Lang:t('success.part_replaced', {part = Lang:t('parts.' .. part)}), 'success')
            end
        end
        
        StopRepairAnim()
        isRepairing = false
        currentVehicle = nil
    end, type == 'full' and {'mechanic_tools', 'repair_kit'} or {'mechanic_tools'})
end

local function DiagnoseVehicle(vehicle)
    if not DoesEntityExist(vehicle) then return end
    
    local engineHealth = GetVehicleEngineHealth(vehicle)
    local bodyHealth = GetVehicleBodyHealth(vehicle)
    
    local diagnosis = {
        engine = math.floor((engineHealth / 1000.0) * 100),
        body = math.floor((bodyHealth / 1000.0) * 100)
    }
    
    -- Send diagnosis to server for processing
    TriggerServerEvent('sl-mechanics:server:ProcessDiagnosis', NetworkGetNetworkIdFromEntity(vehicle), diagnosis)
end

local function ToggleLift()
    if not currentLift then
        -- Find nearest lift
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        -- This would need to be replaced with actual lift object detection
        local lift = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, `prop_car_lift`, false, false, false)
        
        if lift and DoesEntityExist(lift) then
            currentLift = lift
        else
            SLCore.Functions.Notify(Lang:t('error.not_near_lift'), 'error')
            return
        end
    end
    
    if not liftRaised then
        -- Raise lift animation/movement
        SetEntityHeightAboveGround(currentLift, 2.0)
        liftRaised = true
        SLCore.Functions.Notify(Lang:t('success.lift_raised'), 'success')
    else
        -- Lower lift animation/movement
        SetEntityHeightAboveGround(currentLift, 0.0)
        liftRaised = false
        SLCore.Functions.Notify(Lang:t('success.lift_lowered'), 'success')
    end
end

-- Events
RegisterNetEvent('sl-mechanics:client:RepairVehicle', function(data)
    local vehicle = GetVehicleInFront()
    if vehicle then
        RepairVehicle(vehicle, data.type, data.part)
    else
        SLCore.Functions.Notify(Lang:t('error.no_vehicle'), 'error')
    end
end)

RegisterNetEvent('sl-mechanics:client:DiagnoseVehicle', function()
    local vehicle = GetVehicleInFront()
    if vehicle then
        DiagnoseVehicle(vehicle)
    else
        SLCore.Functions.Notify(Lang:t('error.no_vehicle'), 'error')
    end
end)

RegisterNetEvent('sl-mechanics:client:ToggleLift', function()
    ToggleLift()
end)

-- Exports
exports('RepairVehicle', RepairVehicle)
exports('DiagnoseVehicle', DiagnoseVehicle)
exports('ToggleLift', ToggleLift)
