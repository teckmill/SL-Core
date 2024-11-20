local SLCore = exports['sl-core']:GetCoreObject()
local isDead = false
local deathTime = 0
local lastDamage = {}

-- Death Functions
function OnPlayerDeath()
    if isDead then return end
    isDead = true
    deathTime = Config.WaitingTime
    
    StartDeathTimer()
    StartDeathCam()
    
    TriggerServerEvent("sl-ambulance:server:SetDeathStatus", true)
end

function StartDeathTimer()
    CreateThread(function()
        while isDead do
            Wait(1000)
            deathTime = deathTime - 1
            
            if deathTime <= 0 then
                if IsControlPressed(0, 38) then
                    RespawnPlayer()
                else
                    SLCore.Functions.Notify("Press [E] to respawn", "info")
                end
            else
                SLCore.Functions.Notify("Respawn available in: " .. deathTime .. " seconds", "error")
            end
        end
    end)
end

function StartDeathCam()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, coords.x, coords.y, coords.z + 3.0)
    SetCamRot(cam, -90.0, 0.0, 0.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
end

function RespawnPlayer()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    DoScreenFadeOut(800)
    while not IsScreenFadedOut() do Wait(10) end
    
    local hospital = GetNearestHospital(coords)
    SetEntityCoords(ped, hospital.beds[1].coords.x, hospital.beds[1].coords.y, hospital.beds[1].coords.z)
    SetEntityHeading(ped, hospital.beds[1].coords.w)
    
    TriggerServerEvent("sl-ambulance:server:RespawnPlayer")
    
    Wait(500)
    DoScreenFadeIn(800)
end

function GetNearestHospital(coords)
    local closest = nil
    local closestDist = 999999.9
    
    for k, v in pairs(Config.Hospitals) do
        local dist = #(coords - v.blip.coords)
        if dist < closestDist then
            closest = v
            closestDist = dist
        end
    end
    
    return closest
end

-- Events
RegisterNetEvent('sl-ambulance:client:Revive', function()
    local ped = PlayerPedId()
    
    isDead = false
    deathTime = 0
    
    if cam then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(cam, false)
        cam = nil
    end
    
    NetworkResurrectLocalPlayer(GetEntityCoords(ped), GetEntityHeading(ped), true, false)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
    
    TriggerServerEvent("sl-ambulance:server:SetDeathStatus", false)
end)

-- Damage Handler
CreateThread(function()
    while true do
        Wait(100)
        local ped = PlayerPedId()
        
        if not isDead then
            local health = GetEntityHealth(ped)
            if health <= Config.MinimumHealth then
                local hit, bone = GetPedLastDamageBone(ped)
                if hit then
                    lastDamage = {
                        bone = bone,
                        weapon = GetPedCauseOfDeath(ped)
                    }
                end
                OnPlayerDeath()
            end
        end
    end
end) 