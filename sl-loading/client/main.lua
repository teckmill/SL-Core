local SL = exports['sl-core']:GetCoreObject()
local isLoading = false
local loadingProgress = 0
local loadingStage = 1

-- NUI Messages
local function SendNUIMessage(data)
    if not data then return end
    SendNUIMessage({
        type = data.type,
        progress = data.progress,
        message = data.message
    })
end

-- Loading Screen Functions
local function StartLoading()
    if isLoading then return end
    isLoading = true
    loadingProgress = 0
    loadingStage = 1
    
    -- Display loading screen
    DoScreenFadeOut(0)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    
    -- Start the loading sequence
    Citizen.CreateThread(function()
        while isLoading do
            -- Simulate loading progress
            if loadingProgress < 100 then
                loadingProgress = loadingProgress + math.random(1, 3)
                if loadingProgress > 100 then loadingProgress = 100 end
                
                -- Update NUI
                SendNUIMessage({
                    type = 'updateProgress',
                    progress = loadingProgress
                })
                
                -- Update loading stage messages
                if loadingProgress >= 25 and loadingStage == 1 then
                    loadingStage = 2
                    SendNUIMessage({
                        type = 'setMessage',
                        message = Config.ProgressMessages[2]
                    })
                elseif loadingProgress >= 50 and loadingStage == 2 then
                    loadingStage = 3
                    SendNUIMessage({
                        type = 'setMessage',
                        message = Config.ProgressMessages[3]
                    })
                elseif loadingProgress >= 75 and loadingStage == 3 then
                    loadingStage = 4
                    SendNUIMessage({
                        type = 'setMessage',
                        message = Config.ProgressMessages[4]
                    })
                end
            else
                -- Loading complete
                Citizen.Wait(1000) -- Wait for final animations
                StopLoading()
                break
            end
            
            Citizen.Wait(50)
        end
    end)
end

local function StopLoading()
    if not isLoading then return end
    
    -- Send shutdown message to NUI
    SendNUIMessage({
        type = 'shutdown'
    })
    
    -- Reset variables
    isLoading = false
    loadingProgress = 0
    loadingStage = 1
    
    -- Fade in screen
    DoScreenFadeIn(1000)
end

-- NUI Callbacks
RegisterNUICallback('shutdownComplete', function(data, cb)
    -- Handle any cleanup after NUI shutdown
    cb('ok')
end)

-- Event Handlers
RegisterNetEvent('sl-loading:client:Start', function()
    StartLoading()
end)

RegisterNetEvent('sl-loading:client:Stop', function()
    StopLoading()
end)

-- Export Functions
exports('StartLoading', StartLoading)
exports('StopLoading', StopLoading)

-- Initialize
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Initialize loading screen
    if Config.Debug then
        print('[sl-loading] Loading screen initialized')
    end
end)
