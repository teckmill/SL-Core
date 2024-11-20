local SLCore = nil
local CoreReady = false
local PlayerData = {}
local isInPayrollZone = false
local payrollPed = nil
local payrollBlip = nil

-- Initialize core
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                PlayerData = SLCore.Functions.GetPlayerData()
                print('^2[SL-Payroll] ^7Successfully connected to SL-Core')
                InitializePayroll()
                break
            end
        end
        Wait(100)
    end
end)

-- Events
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    InitializePayroll()
end)

RegisterNetEvent('SLCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    RemovePayrollBlip()
    DeletePayrollPed()
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Functions
function InitializePayroll()
    if not CoreReady then return end
    CreatePayrollBlip()
    CreatePayrollPed()
end

function CreatePayrollBlip()
    if payrollBlip then RemovePayrollBlip() end
    
    local coords = Config.PayrollLocation
    payrollBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    
    SetBlipSprite(payrollBlip, Config.Blip.sprite)
    SetBlipDisplay(payrollBlip, 4)
    SetBlipScale(payrollBlip, Config.Blip.scale)
    SetBlipColour(payrollBlip, Config.Blip.color)
    SetBlipAsShortRange(payrollBlip, true)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blip.label)
    EndTextCommandSetBlipName(payrollBlip)
end

function RemovePayrollBlip()
    if payrollBlip then
        RemoveBlip(payrollBlip)
        payrollBlip = nil
    end
end

function CreatePayrollPed()
    if payrollPed then DeletePayrollPed() end
    
    local coords = Config.PayrollLocation
    RequestModel(Config.PedModel)
    while not HasModelLoaded(Config.PedModel) do
        Wait(10)
    end
    
    payrollPed = CreatePed(4, Config.PedModel, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
    SetEntityHeading(payrollPed, coords.w)
    FreezeEntityPosition(payrollPed, true)
    SetEntityInvincible(payrollPed, true)
    SetBlockingOfNonTemporaryEvents(payrollPed, true)
    
    exports['sl-target']:AddTargetEntity(payrollPed, {
        options = {
            {
                type = "client",
                event = "sl-payroll:client:OpenPayrollMenu",
                icon = "fas fa-money-bill",
                label = Lang:t('menu.payroll'),
                job = Config.PayrollJob
            }
        },
        distance = 2.0
    })
end

function DeletePayrollPed()
    if payrollPed then
        DeleteEntity(payrollPed)
        payrollPed = nil
    end
end

function OpenPayrollMenu()
    if not CoreReady then return end
    
    SLCore.Functions.TriggerCallback('sl-payroll:server:GetPayrollInfo', function(info)
        if not info then return end
        
        local elements = {
            {
                header = Lang:t('menu.payroll'),
                isMenuHeader = true
            }
        }
        
        if info.canCollect then
            table.insert(elements, {
                header = Lang:t('menu.collect_paycheck'),
                txt = Lang:t('info.paycheck_available', {amount = info.amount}),
                params = {
                    event = 'sl-payroll:client:CollectPaycheck',
                    args = {
                        amount = info.amount
                    }
                }
            })
        else
            table.insert(elements, {
                header = Lang:t('info.next_paycheck'),
                txt = info.nextPaycheck,
                isMenuHeader = true
            })
        end
        
        if PlayerData.job.grade.level >= Config.ManagementGrade then
            table.insert(elements, {
                header = Lang:t('menu.manage_salaries'),
                txt = Lang:t('info.salary_management'),
                params = {
                    event = 'sl-payroll:client:OpenSalaryMenu'
                }
            })
            
            table.insert(elements, {
                header = Lang:t('menu.manage_bonuses'),
                txt = Lang:t('info.bonus_management'),
                params = {
                    event = 'sl-payroll:client:OpenBonusMenu'
                }
            })
        end
        
        exports['sl-menu']:openMenu(elements)
    end)
end

-- Events
RegisterNetEvent('sl-payroll:client:OpenPayrollMenu', function()
    OpenPayrollMenu()
end)

RegisterNetEvent('sl-payroll:client:CollectPaycheck', function(data)
    if not CoreReady then return end
    
    TriggerServerEvent('sl-payroll:server:CollectPaycheck')
end)

RegisterNetEvent('sl-payroll:client:OpenSalaryMenu', function()
    if not CoreReady then return end
    if PlayerData.job.grade.level < Config.ManagementGrade then return end
    
    SLCore.Functions.TriggerCallback('sl-payroll:server:GetSalaryInfo', function(info)
        if not info then return end
        
        local elements = {
            {
                header = Lang:t('menu.salary_management'),
                isMenuHeader = true
            }
        }
        
        for grade, salary in pairs(info.grades) do
            table.insert(elements, {
                header = Lang:t('menu.set_salary'),
                txt = string.format('Grade %s - Current: $%s', grade, salary),
                params = {
                    event = 'sl-payroll:client:SetSalary',
                    args = {
                        grade = grade,
                        current = salary
                    }
                }
            })
        end
        
        exports['sl-menu']:openMenu(elements)
    end)
end)

RegisterNetEvent('sl-payroll:client:OpenBonusMenu', function()
    if not CoreReady then return end
    if PlayerData.job.grade.level < Config.ManagementGrade then return end
    
    SLCore.Functions.TriggerCallback('sl-payroll:server:GetEmployees', function(employees)
        if not employees then return end
        
        local elements = {
            {
                header = Lang:t('menu.bonus_management'),
                isMenuHeader = true
            }
        }
        
        for _, employee in pairs(employees) do
            table.insert(elements, {
                header = Lang:t('menu.give_bonus'),
                txt = string.format('%s (%s)', employee.name, employee.grade),
                params = {
                    event = 'sl-payroll:client:GiveBonus',
                    args = {
                        target = employee.id,
                        name = employee.name
                    }
                }
            })
        end
        
        exports['sl-menu']:openMenu(elements)
    end)
end)

-- Commands
RegisterCommand('payroll', function()
    if not CoreReady then return end
    OpenPayrollMenu()
end, false)

-- Exports
exports('OpenPayrollMenu', OpenPayrollMenu)
