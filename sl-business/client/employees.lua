local SLCore = exports['sl-core']:GetCoreObject()

-- Employee Menu Functions
function OpenEmployeeMenu()
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local menu = {
        {
            header = Lang:t('info.employee_menu'),
            icon = "fas fa-users",
            isMenuHeader = true
        },
        {
            header = "Hire Employee",
            txt = "Add a new employee",
            icon = "fas fa-user-plus",
            params = {
                event = "sl-business:client:hireEmployee",
            }
        },
        {
            header = "Manage Employees",
            txt = "View and manage current employees",
            icon = "fas fa-user-cog",
            params = {
                event = "sl-business:client:manageEmployees",
            }
        },
        {
            header = Lang:t('menu.back'),
            icon = "fas fa-arrow-left",
            params = {
                event = "sl-business:client:openMenu"
            }
        }
    }

    exports['sl-menu']:openMenu(menu)
end

function OpenManageEmployeesMenu()
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local menu = {
        {
            header = "Manage Employees",
            icon = "fas fa-users",
            isMenuHeader = true
        }
    }

    -- Add employee entries
    for citizenid, employee in pairs(business.employees) do
        menu[#menu + 1] = {
            header = employee.name,
            txt = "Role: " .. employee.role .. " | Wage: $" .. employee.wage,
            icon = "fas fa-user",
            params = {
                event = "sl-business:client:employeeOptions",
                args = {
                    employeeId = citizenid,
                    employee = employee
                }
            }
        }
    end

    -- Add back button
    menu[#menu + 1] = {
        header = Lang:t('menu.back'),
        icon = "fas fa-arrow-left",
        params = {
            event = "sl-business:client:openEmployeeMenu"
        }
    }

    exports['sl-menu']:openMenu(menu)
end

function OpenEmployeeOptionsMenu(data)
    if not data.employeeId or not data.employee then return end

    local menu = {
        {
            header = data.employee.name,
            txt = "Role: " .. data.employee.role,
            icon = "fas fa-user",
            isMenuHeader = true
        },
        {
            header = "Update Role",
            txt = "Change employee's role",
            icon = "fas fa-user-tag",
            params = {
                event = "sl-business:client:updateEmployeeRole",
                args = {
                    employeeId = data.employeeId,
                    currentRole = data.employee.role
                }
            }
        },
        {
            header = "Update Wage",
            txt = "Change employee's wage",
            icon = "fas fa-dollar-sign",
            params = {
                event = "sl-business:client:updateEmployeeWage",
                args = {
                    employeeId = data.employeeId,
                    currentWage = data.employee.wage
                }
            }
        },
        {
            header = "Fire Employee",
            txt = "Remove employee from business",
            icon = "fas fa-user-times",
            params = {
                event = "sl-business:client:fireEmployee",
                args = {
                    employeeId = data.employeeId,
                    name = data.employee.name
                }
            }
        },
        {
            header = Lang:t('menu.back'),
            icon = "fas fa-arrow-left",
            params = {
                event = "sl-business:client:manageEmployees"
            }
        }
    }

    exports['sl-menu']:openMenu(menu)
end

-- Events
RegisterNetEvent('sl-business:client:hireEmployee', function()
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local input = exports['sl-input']:ShowInput({
        header = "Hire Employee",
        submitText = "Confirm",
        inputs = {
            {
                text = "Citizen ID",
                name = "citizenid",
                type = "text",
                isRequired = true
            },
            {
                text = "Role",
                name = "role",
                type = "text",
                isRequired = true
            },
            {
                text = "Wage",
                name = "wage",
                type = "number",
                isRequired = true,
                default = 50
            }
        }
    })

    if input and input.citizenid and input.role and input.wage then
        TriggerServerEvent('sl-business:server:hireEmployee', business.id, input.citizenid, input.role, tonumber(input.wage))
    end
end)

RegisterNetEvent('sl-business:client:updateEmployeeRole', function(data)
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local input = exports['sl-input']:ShowInput({
        header = "Update Role",
        submitText = "Confirm",
        inputs = {
            {
                text = "New Role",
                name = "role",
                type = "text",
                isRequired = true,
                default = data.currentRole
            }
        }
    })

    if input and input.role then
        TriggerServerEvent('sl-business:server:updateEmployee', business.id, data.employeeId, {
            role = input.role
        })
    end
end)

RegisterNetEvent('sl-business:client:updateEmployeeWage', function(data)
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local input = exports['sl-input']:ShowInput({
        header = "Update Wage",
        submitText = "Confirm",
        inputs = {
            {
                text = "New Wage",
                name = "wage",
                type = "number",
                isRequired = true,
                default = data.currentWage
            }
        }
    })

    if input and input.wage then
        TriggerServerEvent('sl-business:server:updateEmployee', business.id, data.employeeId, {
            wage = tonumber(input.wage)
        })
    end
end)

RegisterNetEvent('sl-business:client:fireEmployee', function(data)
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local confirm = exports['sl-input']:ShowInput({
        header = "Fire Employee",
        submitText = "Confirm",
        inputs = {
            {
                text = "Type 'CONFIRM' to fire " .. data.name,
                name = "confirm",
                type = "text",
                isRequired = true
            }
        }
    })

    if confirm and confirm.confirm == 'CONFIRM' then
        TriggerServerEvent('sl-business:server:fireEmployee', business.id, data.employeeId)
    end
end)

-- Menu Events
RegisterNetEvent('sl-business:client:openEmployeeMenu', OpenEmployeeMenu)
RegisterNetEvent('sl-business:client:manageEmployees', OpenManageEmployeesMenu)
RegisterNetEvent('sl-business:client:employeeOptions', OpenEmployeeOptionsMenu)
