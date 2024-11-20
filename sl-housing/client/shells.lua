local SLCore = exports['sl-core']:GetCoreObject()

local shells = {
    -- Starter Homes
    ['shell_trailer'] = {
        model = `shell_trailer1`,
        offset = vector3(0.0, 0.0, 0.0),
        price = 35000
    },
    ['shell_container'] = {
        model = `container_shell`,
        offset = vector3(0.0, 0.0, 0.0),
        price = 45000
    },
    
    -- Small Houses
    ['shell_lester'] = {
        model = `shell_lester`,
        offset = vector3(-1.5, -3.2, -1.0),
        price = 75000
    },
    ['shell_ranch'] = {
        model = `shell_ranch`,
        offset = vector3(-1.0, -1.0, 0.0),
        price = 85000
    },
    
    -- Medium Houses
    ['shell_trevor'] = {
        model = `shell_trevor`,
        offset = vector3(0.0, -1.0, -1.0),
        price = 125000
    },
    ['shell_v16low'] = {
        model = `shell_v16low`,
        offset = vector3(1.5, -2.0, 1.0),
        price = 150000
    },
    
    -- Large Houses
    ['shell_highend'] = {
        model = `shell_highend`,
        offset = vector3(-22.0, -0.5, 1.5),
        price = 500000
    },
    ['shell_highendv2'] = {
        model = `shell_highendv2`,
        offset = vector3(-10.0, 0.0, 0.5),
        price = 750000
    },
    
    -- Apartments
    ['shell_michael'] = {
        model = `shell_michael`,
        offset = vector3(-8.0, 3.0, 1.0),
        price = 350000
    },
    ['shell_apartment1'] = {
        model = `shell_apartment1`,
        offset = vector3(-2.0, -1.0, 1.0),
        price = 275000
    },
    
    -- Offices
    ['shell_office1'] = {
        model = `shell_office1`,
        offset = vector3(1.5, 5.0, -1.5),
        price = 250000
    },
    ['shell_office2'] = {
        model = `shell_office2`,
        offset = vector3(3.0, 1.0, -2.0),
        price = 350000
    }
}

local function LoadShell(shellType)
    if not shells[shellType] then return nil end
    
    local shell = shells[shellType]
    if not IsModelInCdimage(shell.model) then return nil end
    
    RequestModel(shell.model)
    while not HasModelLoaded(shell.model) do
        Wait(10)
    end
    
    return shell
end

local function CreateShell(shellType, position)
    local shell = LoadShell(shellType)
    if not shell then return nil end
    
    local object = CreateObject(shell.model, position.x, position.y, position.z, false, false, false)
    if not object then return nil end
    
    FreezeEntityPosition(object, true)
    SetEntityInvincible(object, true)
    SetModelAsNoLongerNeeded(shell.model)
    
    -- Calculate entrance position
    local entrance = vector3(
        position.x + shell.offset.x,
        position.y + shell.offset.y,
        position.z + shell.offset.z
    )
    
    return {
        object = object,
        entrance = entrance,
        type = shellType,
        position = position
    }
end

local function DeleteShell(shellData)
    if not shellData or not shellData.object then return end
    if not DoesEntityExist(shellData.object) then return end
    
    DeleteEntity(shellData.object)
end

-- Events
RegisterNetEvent('sl-housing:client:PreviewShell', function(shellType, position)
    local shellData = CreateShell(shellType, position)
    if not shellData then
        SLCore.Functions.Notify(Lang:t('error.invalid_shell'), 'error')
        return
    end
    
    -- Set shell alpha for preview
    SetEntityAlpha(shellData.object, 200, false)
    
    -- Create preview blip
    local blip = AddBlipForCoord(shellData.entrance)
    SetBlipSprite(blip, 40)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Lang:t('info.house_preview'))
    EndTextCommandSetBlipName(blip)
    
    -- Wait for confirmation
    exports['sl-core']:ShowHelpNotification(Lang:t('info.preview_controls'))
    
    local confirmed = false
    local cancelled = false
    
    CreateThread(function()
        while not confirmed and not cancelled do
            Wait(0)
            
            if IsControlJustPressed(0, 38) then -- E
                confirmed = true
            elseif IsControlJustPressed(0, 177) then -- BACKSPACE
                cancelled = true
            end
        end
        
        -- Cleanup
        DeleteShell(shellData)
        RemoveBlip(blip)
        
        if confirmed then
            TriggerServerEvent('sl-housing:server:PurchaseHouse', shellType, position)
        end
    end)
end)

-- Exports
exports('GetShells', function()
    return shells
end)

exports('CreateShell', CreateShell)
exports('DeleteShell', DeleteShell)
