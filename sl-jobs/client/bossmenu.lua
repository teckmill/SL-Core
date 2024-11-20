local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local currentBossMenu = nil

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Boss Menu Functions
function OpenBossMenu()
    if not CanAccessBossMenu() then return end
    
    local menu = {
        {
            header = "Boss Menu - " .. PlayerData.job.label,
            isMenuHeader = true
        },
        {
            header = "Employee Management",
            txt = "Manage your employees",
            params = {
                event = "sl-jobs:client:OpenEmployeeMenu",
            }
        },
        {
            header = "Society Management",
            txt = "Manage society funds",
            params = {
                event = "sl-jobs:client:OpenSocietyMenu",
            }
        },
        {
            header = "Job Settings",
            txt = "Configure job settings",
            params = {
                event = "sl-jobs:client:OpenJobSettings",
            }
        }
    }
    
    exports['sl-menu']:openMenu(menu)
end

function OpenEmployeeMenu()
    SLCore.Functions.TriggerCallback('sl-jobs:server:GetEmployees', function(employees)
        local menu = {
            {
                header = "< Go Back",
                params = {
                    event = "sl-jobs:client:OpenBossMenu"
                }
            },
            {
                header = "Employee Management",
                isMenuHeader = true
            }
        }
        
        for _, employee in pairs(employees) do
            menu[#menu + 1] = {
                header = employee.name,
                txt = "Grade: " .. employee.grade_label,
                params = {
                    event = "sl-jobs:client:ManageEmployee",
                    args = {
                        employee = employee
                    }
                }
            }
        end
        
        exports['sl-menu']:openMenu(menu)
    end)
end

function ManageEmployee(data)
    local employee = data.employee
    local menu = {
        {
            header = "< Go Back",
            params = {
                event = "sl-jobs:client:OpenEmployeeMenu"
            }
        },
        {
            header = "Manage " .. employee.name,
            isMenuHeader = true
        },
        {
            header = "Promote Employee",
            txt = "Current Grade: " .. employee.grade_label,
            params = {
                event = "sl-jobs:client:PromoteEmployee",
                args = {
                    citizenid = employee.citizenid
                }
            }
        },
        {
            header = "Demote Employee",
            txt = "Current Grade: " .. employee.grade_label,
            params = {
                event = "sl-jobs:client:DemoteEmployee",
                args = {
                    citizenid = employee.citizenid
                }
            }
        },
        {
            header = "Fire Employee",
            txt = "Remove from job",
            params = {
                event = "sl-jobs:client:FireEmployee",
                args = {
                    citizenid = employee.citizenid
                }
            }
        }
    }
    
    exports['sl-menu']:openMenu(menu)
end

-- Events
RegisterNetEvent('sl-jobs:client:OpenBossMenu', function()
    OpenBossMenu()
end)

RegisterNetEvent('sl-jobs:client:OpenEmployeeMenu', function()
    OpenEmployeeMenu()
end)

RegisterNetEvent('sl-jobs:client:ManageEmployee', function(data)
    ManageEmployee(data)
end)

-- Utility Functions
function CanAccessBossMenu()
    if not PlayerData.job then return false end
    
    local jobConfig = Config.Jobs[PlayerData.job.name]
    if not jobConfig then return false end
    
    local gradeConfig = jobConfig.grades[tostring(PlayerData.job.grade)]
    return gradeConfig and (gradeConfig.isBoss or gradeConfig.canManage)
end

-- Export
exports('OpenBossMenu', OpenBossMenu) 