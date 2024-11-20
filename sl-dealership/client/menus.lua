local SLCore = exports['sl-core']:GetCoreObject()

-- Vehicle Viewing Menu
function OpenVehicleMenu(vehicleConfig, displayId)
    local PlayerData = SLCore.Functions.GetPlayerData()
    local isCarDealer = PlayerData.job.name == Config.Commission.jobName
    
    local menu = {
        {
            header = vehicleConfig.name,
            isMenuHeader = true,
            txt = "Price: $" .. vehicleConfig.price
        },
        {
            header = "View Vehicle Stats",
            txt = "Check vehicle performance stats",
            params = {
                event = "sl-dealership:client:ViewStats",
                args = {
                    vehicle = vehicleConfig,
                    displayId = displayId
                }
            }
        }
    }
    
    -- Test Drive Option
    if Config.TestDrive.enabled then
        menu[#menu + 1] = {
            header = "Test Drive",
            txt = "Deposit Required: $" .. Config.Dealerships[CurrentDealership].testDrive.deposit,
            params = {
                event = "sl-dealership:client:StartTestDrive",
                args = {
                    vehicle = vehicleConfig,
                    displayId = displayId
                }
            }
        }
    end
    
    -- Purchase Options
    if isCarDealer then
        menu[#menu + 1] = {
            header = "Sell Vehicle",
            txt = "Process vehicle sale",
            params = {
                event = "sl-dealership:client:SellVehicle",
                args = {
                    vehicle = vehicleConfig,
                    displayId = displayId
                }
            }
        }
    else
        menu[#menu + 1] = {
            header = "Purchase Vehicle",
            txt = "Buy for $" .. vehicleConfig.price,
            params = {
                event = "sl-dealership:client:PurchaseVehicle",
                args = {
                    vehicle = vehicleConfig,
                    displayId = displayId,
                    finance = false
                }
            }
        }
        
        if Config.Finance.enabled then
            menu[#menu + 1] = {
                header = "Finance Vehicle",
                txt = "Minimum Down Payment: " .. Config.Finance.minDownPayment .. "%",
                params = {
                    event = "sl-dealership:client:FinanceVehicle",
                    args = {
                        vehicle = vehicleConfig,
                        displayId = displayId
                    }
                }
            }
        end
    end
    
    exports['sl-menu']:openMenu(menu)
end

-- Display Change Menu
function OpenDisplayMenu(displayId)
    local menu = {
        {
            header = "Change Display Vehicle",
            isMenuHeader = true
        }
    }
    
    for category, data in pairs(Config.Categories) do
        menu[#menu + 1] = {
            header = data.label,
            txt = "Select from " .. data.label,
            params = {
                event = "sl-dealership:client:SelectCategory",
                args = {
                    category = category,
                    displayId = displayId
                }
            }
        }
    end
    
    exports['sl-menu']:openMenu(menu)
end

-- Category Selection Menu
RegisterNetEvent('sl-dealership:client:SelectCategory', function(data)
    local menu = {
        {
            header = "< Go Back",
            params = {
                event = "sl-dealership:client:ChangeDisplay",
                args = {
                    displayId = data.displayId
                }
            }
        }
    }
    
    local vehicles = Config.Categories[data.category].vehicles
    for i, vehicle in ipairs(vehicles) do
        menu[#menu + 1] = {
            header = vehicle.name,
            txt = "Price: $" .. vehicle.price,
            params = {
                event = "sl-dealership:client:UpdateDisplay",
                args = {
                    category = data.category,
                    index = i,
                    displayId = data.displayId
                }
            }
        }
    end
    
    exports['sl-menu']:openMenu(menu)
end)

-- Vehicle Stats Menu
RegisterNetEvent('sl-dealership:client:ViewStats', function(data)
    local vehicle = data.vehicle
    local stats = GetVehicleStats(vehicle.model)
    
    local menu = {
        {
            header = vehicle.name .. " Stats",
            isMenuHeader = true
        },
        {
            header = "Performance",
            txt = "Speed: " .. stats.speed .. "\nAcceleration: " .. stats.acceleration .. "\nBraking: " .. stats.braking .. "\nHandling: " .. stats.handling,
            isMenuHeader = true
        },
        {
            header = "< Back",
            params = {
                event = "sl-dealership:client:ViewVehicle",
                args = {
                    displayId = data.displayId
                }
            }
        }
    }
    
    exports['sl-menu']:openMenu(menu)
end)

-- Update Display Vehicle
RegisterNetEvent('sl-dealership:client:UpdateDisplay', function(data)
    ChangeDisplayVehicle(data.displayId, data.category, data.index)
    SLCore.Functions.Notify('Display vehicle updated!', 'success')
end)

-- Utility Functions
function GetVehicleStats(model)
    local stats = {
        speed = GetVehicleModelMaxSpeed(GetHashKey(model)),
        acceleration = GetVehicleModelAcceleration(GetHashKey(model)),
        braking = GetVehicleModelMaxBraking(GetHashKey(model)),
        handling = GetVehicleModelMaxTraction(GetHashKey(model))
    }
    
    -- Normalize stats to 0-100 scale
    stats.speed = math.floor((stats.speed / 150) * 100)
    stats.acceleration = math.floor(stats.acceleration * 100)
    stats.braking = math.floor(stats.braking * 100)
    stats.handling = math.floor(stats.handling * 10)
    
    return stats
end 