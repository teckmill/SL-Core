local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local CurrentAccount = nil
local CurrentZone = nil
local NearATM = false
local NearBank = false

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    TriggerServerEvent('sl-banking:server:GetAccounts')
    InitializeBankingZones()
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Zone Management
function InitializeBankingZones()
    -- Create zones for banks
    for k, v in pairs(Config.Banks) do
        exports['sl-target']:AddBoxZone("bank_" .. k, vector3(v.coords.x, v.coords.y, v.coords.z), 2.0, 2.0, {
            name = "bank_" .. k,
            heading = v.coords.w,
            debugPoly = Config.Debug,
            minZ = v.coords.z - 1.0,
            maxZ = v.coords.z + 2.0
        }, {
            options = {
                {
                    type = "client",
                    event = "sl-banking:client:OpenBankMenu",
                    icon = "fas fa-university",
                    label = "Access Bank"
                }
            },
            distance = 2.0
        })

        -- Create blip
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(blip, v.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, v.blip.scale)
        SetBlipColour(blip, v.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.label)
        EndTextCommandSetBlipName(blip)
    end
end

-- ATM Detection
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local inRange = false

            for _, model in pairs(Config.ATMModels) do
                local atm = GetClosestObjectOfType(pos.x, pos.y, pos.z, 3.0, model, false, false, false)
                if atm ~= 0 then
                    local atmPos = GetEntityCoords(atm)
                    local dist = #(pos - atmPos)
                    if dist <= 2.0 then
                        inRange = true
                        if not NearATM then
                            exports['sl-target']:AddTargetEntity(atm, {
                                options = {
                                    {
                                        type = "client",
                                        event = "sl-banking:client:OpenATM",
                                        icon = "fas fa-credit-card",
                                        label = "Use ATM"
                                    }
                                },
                                distance = 2.0
                            })
                        end
                        NearATM = true
                        break
                    end
                end
            end

            if not inRange and NearATM then
                exports['sl-target']:RemoveTargetEntity(atm, "Use ATM")
                NearATM = false
            end
        end
        Wait(1000)
    end
end)

-- UI Functions
function OpenBankUI(data)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openBank",
        accounts = data.accounts,
        transactions = data.transactions,
        investments = data.investments,
        loans = data.loans
    })
end

function OpenATMUI(data)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openATM",
        accounts = data.accounts
    })
end

-- Events
RegisterNetEvent('sl-banking:client:OpenBankMenu', function()
    TriggerServerEvent('sl-banking:server:GetAccounts')
end)

RegisterNetEvent('sl-banking:client:OpenATM', function()
    TriggerServerEvent('sl-banking:server:GetAccounts')
end)

RegisterNetEvent('sl-banking:client:ReceiveAccounts', function(accounts)
    if NearATM then
        OpenATMUI({accounts = accounts})
    else
        TriggerServerEvent('sl-banking:server:GetTransactions', accounts[1].number)
        CurrentAccount = accounts[1].number
    end
end)

RegisterNetEvent('sl-banking:client:ReceiveTransactions', function(transactions)
    OpenBankUI({
        accounts = accounts,
        transactions = transactions,
        investments = investments,
        loans = loans
    })
end)

RegisterNetEvent('sl-banking:client:AccountCreated', function(success, result)
    if success then
        SLCore.Functions.Notify('Account created successfully!', 'success')
        TriggerServerEvent('sl-banking:server:GetAccounts')
    else
        SLCore.Functions.Notify(result, 'error')
    end
end)

-- NUI Callbacks
RegisterNUICallback('closeBank', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('deposit', function(data, cb)
    if data.amount and data.account then
        TriggerServerEvent('sl-banking:server:Deposit', data.account, data.amount)
    end
    cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
    if data.amount and data.account then
        TriggerServerEvent('sl-banking:server:Withdraw', data.account, data.amount)
    end
    cb('ok')
end)

RegisterNUICallback('transfer', function(data, cb)
    if data.amount and data.from and data.to then
        TriggerServerEvent('sl-banking:server:Transfer', data.from, data.to, data.amount)
    end
    cb('ok')
end)

RegisterNUICallback('createAccount', function(data, cb)
    if data.type and data.pin then
        TriggerServerEvent('sl-banking:server:CreateAccount', data.type, data.pin)
    end
    cb('ok')
end)

RegisterNUICallback('requestLoan', function(data, cb)
    if data.type and data.amount and data.term then
        TriggerServerEvent('sl-banking:server:RequestLoan', data.account, data.type, data.amount, data.term)
    end
    cb('ok')
end)

RegisterNUICallback('createInvestment', function(data, cb)
    if data.type and data.amount then
        TriggerServerEvent('sl-banking:server:CreateInvestment', data.account, data.type, data.amount)
    end
    cb('ok')
end)

RegisterNUICallback('getAccountDetails', function(data, cb)
    if data.account then
        TriggerServerEvent('sl-banking:server:GetTransactions', data.account)
        CurrentAccount = data.account
    end
    cb('ok')
end)

-- Commands
RegisterCommand('atm', function()
    if NearATM then
        TriggerEvent('sl-banking:client:OpenATM')
    else
        SLCore.Functions.Notify('No ATM nearby', 'error')
    end
end)

RegisterCommand('bank', function()
    if NearBank then
        TriggerEvent('sl-banking:client:OpenBankMenu')
    else
        SLCore.Functions.Notify('No bank nearby', 'error')
    end
end)
