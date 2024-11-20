local nozzleInHand = false
local nozzleDropped = false
local holdingNozzle = false
local nozzleObject = nil
local nozzleLocation = nil

local function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function AttachNozzle()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    LoadAnimDict("anim@am_hold_up@male")
    TaskPlayAnim(ped, "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, -1, 50, 0, false, false, false)
    
    local model = `prop_cs_fuel_nozle`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    nozzleObject = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)
    AttachEntityToEntity(nozzleObject, ped, GetPedBoneIndex(ped, 18905), 0.13, 0.04, 0.02, 80.0, -90.0, 30.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(model)
    
    nozzleInHand = true
    holdingNozzle = true
end

local function RemoveNozzle()
    if nozzleObject then
        DeleteEntity(nozzleObject)
        nozzleObject = nil
    end
    ClearPedTasks(PlayerPedId())
    nozzleInHand = false
    holdingNozzle = false
end

local function DropNozzle()
    if nozzleObject then
        DetachEntity(nozzleObject, true, true)
        nozzleLocation = GetEntityCoords(nozzleObject)
        nozzleDropped = true
        holdingNozzle = false
    end
end

local function PickupNozzle()
    if nozzleDropped and nozzleLocation then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        if #(coords - nozzleLocation) < 2.0 then
            DeleteEntity(nozzleObject)
            AttachNozzle()
            nozzleDropped = false
        end
    end
end

-- Exports
exports('IsHoldingNozzle', function()
    return holdingNozzle
end)

exports('AttachNozzle', AttachNozzle)
exports('RemoveNozzle', RemoveNozzle)
exports('DropNozzle', DropNozzle)
exports('PickupNozzle', PickupNozzle)
