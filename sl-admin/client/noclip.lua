local SLCore = exports['sl-core']:GetCoreObject()

local noClip = false
local noClipSpeed = 1.0
local noClipEntity = nil

local speeds = {
    ['slow'] = 0.5,
    ['normal'] = 2.0,
    ['fast'] = 5.0,
    ['veryfast'] = 10.0
}

local function toggleNoClip()
    noClip = not noClip
    local ped = PlayerPedId()
    
    if noClip then
        noClipEntity = ped
        if IsPedInAnyVehicle(ped, false) then
            noClipEntity = GetVehiclePedIsIn(ped, false)
        end
        
        SetEntityInvincible(noClipEntity, true)
        SetEntityCollision(noClipEntity, false, false)
        FreezeEntityPosition(noClipEntity, true)
        SetEntityVisible(noClipEntity, false, false)
        SetEveryoneIgnorePlayer(PlayerId(), true)
        SetPoliceIgnorePlayer(PlayerId(), true)
        
        SLCore.Functions.Notify('NoClip Enabled - Use Mouse Wheel to adjust speed', 'success')
    else
        SetEntityInvincible(noClipEntity, false)
        SetEntityCollision(noClipEntity, true, true)
        FreezeEntityPosition(noClipEntity, false)
        SetEntityVisible(noClipEntity, true, false)
        SetEveryoneIgnorePlayer(PlayerId(), false)
        SetPoliceIgnorePlayer(PlayerId(), false)
        
        noClipEntity = nil
        SLCore.Functions.Notify('NoClip Disabled', 'error')
    end
end

local function handleNoClipMovement()
    if not noClip or not noClipEntity then return end
    
    local multiplier = 1.0
    local forward, right, up, p = GetEntityMatrix(noClipEntity)
    
    -- Speed control with mouse wheel
    if IsControlJustPressed(0, 14) then -- Scroll down
        noClipSpeed = noClipSpeed - 0.5
        if noClipSpeed < 0.5 then noClipSpeed = 0.5 end
        SLCore.Functions.Notify('NoClip Speed: ' .. noClipSpeed, 'primary')
    elseif IsControlJustPressed(0, 15) then -- Scroll up
        noClipSpeed = noClipSpeed + 0.5
        if noClipSpeed > 10.0 then noClipSpeed = 10.0 end
        SLCore.Functions.Notify('NoClip Speed: ' .. noClipSpeed, 'primary')
    end
    
    -- Movement
    if IsControlPressed(0, 32) then -- W
        p = p + forward * (noClipSpeed * multiplier)
    end
    if IsControlPressed(0, 33) then -- S
        p = p - forward * (noClipSpeed * multiplier)
    end
    if IsControlPressed(0, 34) then -- A
        p = p - right * (noClipSpeed * multiplier)
    end
    if IsControlPressed(0, 35) then -- D
        p = p + right * (noClipSpeed * multiplier)
    end
    if IsControlPressed(0, 22) then -- Space
        p = p + up * (noClipSpeed * multiplier)
    end
    if IsControlPressed(0, 36) then -- Left Ctrl
        p = p - up * (noClipSpeed * multiplier)
    end
    
    SetEntityCoords(noClipEntity, p.x, p.y, p.z, true, true, true, false)
end

-- Event handlers
RegisterNetEvent('sl-admin:client:ToggleNoClip', function()
    toggleNoClip()
end)

-- Main thread
CreateThread(function()
    while true do
        Wait(0)
        if noClip then
            handleNoClipMovement()
        else
            Wait(500)
        end
    end
end)
