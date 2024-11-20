local SLCore = nil
local CoreReady = false

-- Initialize core
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                break
            end
        end
        Wait(100)
    end
end)

-- Menu Events
RegisterNetEvent('sl-payroll:client:SetSalary', function(data)
    if not CoreReady then return end
    if not data.grade then return end
    
    local dialog = exports['sl-input']:ShowInput({
        header = Lang:t('menu.set_salary'),
        submitText = Lang:t('menu.confirm'),
        inputs = {
            {
                text = Lang:t('menu.amount'),
                name = "amount",
                type = "number",
                isRequired = true,
                default = data.current or 0
            }
        }
    })
    
    if dialog and dialog.amount then
        local amount = tonumber(dialog.amount)
        if amount and amount > 0 then
            TriggerServerEvent('sl-payroll:server:SetSalary', data.grade, amount)
        else
            SLCore.Functions.Notify(Lang:t('error.invalid_amount'), 'error')
        end
    end
end)

RegisterNetEvent('sl-payroll:client:GiveBonus', function(data)
    if not CoreReady then return end
    if not data.target then return end
    
    local dialog = exports['sl-input']:ShowInput({
        header = Lang:t('menu.give_bonus'),
        submitText = Lang:t('menu.confirm'),
        inputs = {
            {
                text = Lang:t('menu.amount'),
                name = "amount",
                type = "number",
                isRequired = true
            }
        }
    })
    
    if dialog and dialog.amount then
        local amount = tonumber(dialog.amount)
        if amount and amount > 0 then
            TriggerServerEvent('sl-payroll:server:GiveBonus', data.target, amount)
        else
            SLCore.Functions.Notify(Lang:t('error.invalid_amount'), 'error')
        end
    end
end)

-- Context Menu Helper Functions
local function CreateSalaryMenu(grades)
    local elements = {
        {
            header = Lang:t('menu.salary_management'),
            isMenuHeader = true
        }
    }
    
    for grade, salary in pairs(grades) do
        table.insert(elements, {
            header = string.format('Grade %s', grade),
            txt = string.format('Current Salary: $%s', salary),
            params = {
                event = 'sl-payroll:client:SetSalary',
                args = {
                    grade = grade,
                    current = salary
                }
            }
        })
    end
    
    return elements
end

local function CreateBonusMenu(employees)
    local elements = {
        {
            header = Lang:t('menu.bonus_management'),
            isMenuHeader = true
        }
    }
    
    for _, employee in pairs(employees) do
        table.insert(elements, {
            header = employee.name,
            txt = string.format('Grade: %s', employee.grade),
            params = {
                event = 'sl-payroll:client:GiveBonus',
                args = {
                    target = employee.id,
                    name = employee.name
                }
            }
        })
    end
    
    return elements
end

-- Exports
exports('CreateSalaryMenu', CreateSalaryMenu)
exports('CreateBonusMenu', CreateBonusMenu)
