local SLCore = nil
local PlayerData = {}
local DoorStates = {}
local NearbyDoors = {}
local CurrentDoor = nil
local isLockpicking = false

-- Initialize SLCore
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
        end
        Wait(100)
    end
    
    -- Initialize player data
    PlayerData = SLCore.Functions.GetPlayerData()
    
    -- Load door states from server
    TriggerServerEvent('sl-doors:server:RequestDoorStates')
end)

-- Event Handlers
RegisterNetEvent('sl-core:client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
end)

RegisterNetEvent('sl-core:client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('sl-doors:client:UpdateDoorState', function(doorId, state)
    DoorStates[doorId] = state
    local doorConfig = Config.Doors[doorId]
    if doorConfig then
        local doorHash = GetHashKey(doorConfig.model)
        if DoesEntityExist(doorHash) then
            DoorSystemSetDoorState(doorHash, state and 0 or 1, false, false)
        end
    end
end)

RegisterNetEvent('sl-doors:client:SetDoorStates', function(states)
    DoorStates = states
    for doorId, state in pairs(states) do
        local doorConfig = Config.Doors[doorId]
        if doorConfig then
            local doorHash = GetHashKey(doorConfig.model)
            if DoesEntityExist(doorHash) then
                DoorSystemSetDoorState(doorHash, state and 0 or 1, false, false)
            end
        end
    end
end)

-- Functions
local function HasAccess(doorId)
    local door = Config.Doors[doorId]
    if not door then return false end
    
    -- Check if player has keys
    if DoorStates[doorId] and DoorStates[doorId].keys then
        if TableContains(DoorStates[doorId].keys, PlayerData.citizenid) then
            return true
        end
    end
    
    -- Check job access
    if door.group and Config.DoorGroups[door.group] then
        local group = Config.DoorGroups[door.group]
        if group.jobs[PlayerData.job.name] then
            local minGrade = group.jobs[PlayerData.job.name]
            return PlayerData.job.grade.level >= minGrade
        end
    end
    
    return false
end

local function ToggleDoor(doorId)
    if not doorId or not Config.Doors[doorId] then return end
    if not HasAccess(doorId) then
        SLCore.Functions.Notify(Lang:t('error.no_access'), 'error')
        return
    end
    
    local currentState = DoorStates[doorId] or Config.DefaultDoorState
    TriggerServerEvent('sl-doors:server:UpdateDoorState', doorId, not currentState)
end

local function LockpickDoor(doorId)
    if isLockpicking then return end
    if not doorId or not Config.Doors[doorId] then return end
    
    local door = Config.Doors[doorId]
    local doorType = Config.DoorTypes[door.type]
    if not doorType then return end
    
    -- Check for required items
    local hasItems = true
    for _, item in ipairs(doorType.requiredItems) do
        if not SLCore.Functions.HasItem(item) then
            hasItems = false
            break
        end
    end
    
    if not hasItems then
        SLCore.Functions.Notify(Lang:t('error.no_lockpick'), 'error')
        return
    end
    
    isLockpicking = true
    SLCore.Functions.Progressbar('lockpicking_door', Lang:t('info.lockpicking'), doorType.lockpickTime * 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'mp_arresting',
        anim = 'a_uncuff',
        flags = 49,
    }, {}, {}, function() -- Done
        isLockpicking = false
        
        -- Check success chance
        if math.random(100) <= doorType.lockpickChance then
            SLCore.Functions.Notify(Lang:t('success.lockpick_success'), 'success')
            TriggerServerEvent('sl-doors:server:UpdateDoorState', doorId, true)
        else
            SLCore.Functions.Notify(Lang:t('error.lockpick_failed'), 'error')
            
            -- Check if lockpick breaks
            if math.random(100) <= doorType.breakChance then
                SLCore.Functions.Notify(Lang:t('error.lockpick_broke'), 'error')
                TriggerServerEvent('sl-doors:server:RemoveLockpick')
            end
        end
    end, function() -- Cancel
        isLockpicking = false
    end)
end

-- Main Thread
CreateThread(function()
    while true do
        local wait = 1000
        if LocalPlayer.state.isLoggedIn then
            local playerCoords = GetEntityCoords(PlayerPedId())
            NearbyDoors = {}
            
            for doorId, door in pairs(Config.Doors) do
                local distance = #(playerCoords - door.coords)
                if distance <= Config.DrawTextRange then
                    wait = 0
                    NearbyDoors[doorId] = distance
                    
                    -- Draw text
                    local state = DoorStates[doorId] or Config.DefaultDoorState
                    local textConfig = state and Config.DrawText.unlocked or Config.DrawText.locked
                    DrawText3D(door.coords.x, door.coords.y, door.coords.z, textConfig.text)
                    
                    -- Check for interaction
                    if distance <= Config.LockRange then
                        if IsControlJustReleased(0, 38) then -- E key
                            ToggleDoor(doorId)
                        elseif IsControlJustReleased(0, 47) then -- G key
                            LockpickDoor(doorId)
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)

-- Auto Door Thread
CreateThread(function()
    while true do
        Wait(1000)
        if LocalPlayer.state.isLoggedIn then
            local playerCoords = GetEntityCoords(PlayerPedId())
            
            for doorId, door in pairs(Config.Doors) do
                if door.auto_distance then
                    local distance = #(playerCoords - door.coords)
                    local currentState = DoorStates[doorId] or Config.DefaultDoorState
                    
                    if distance <= door.auto_distance and HasAccess(doorId) then
                        if currentState then -- Door is locked
                            TriggerServerEvent('sl-doors:server:UpdateDoorState', doorId, false)
                            SetTimeout(door.auto_wait or 5000, function()
                                if #(GetEntityCoords(PlayerPedId()) - door.coords) > door.auto_distance then
                                    TriggerServerEvent('sl-doors:server:UpdateDoorState', doorId, true)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)
