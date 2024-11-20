local SLCore = exports['sl-core']:GetCoreObject()

function OpenGarageMenu(garage, vehicles)
    local garageMenu = {
        {
            header = Config.Garages[garage].label,
            isMenuHeader = true
        }
    }
    
    if #vehicles > 0 then
        for k, v in pairs(vehicles) do
            local enginePercent = math.ceil(v.engine / 10)
            local bodyPercent = math.ceil(v.body / 10)
            local fuelPercent = math.ceil(v.fuel)
            
            garageMenu[#garageMenu + 1] = {
                header = v.vehicle,
                txt = 'Plate: ' .. v.plate .. ' | Engine: ' .. enginePercent .. '% | Body: ' .. bodyPercent .. '% | Fuel: ' .. fuelPercent .. '%',
                params = {
                    event = 'sl-garage:client:SpawnVehicle',
                    args = {
                        vehicle = v,
                        garage = garage
                    }
                }
            }
        end
    else
        garageMenu[#garageMenu + 1] = {
            header = "Empty Garage",
            txt = "No vehicles stored in this garage",
            params = {
                event = "sl-menu:client:closeMenu"
            }
        }
    end
    
    exports['sl-menu']:openMenu(garageMenu)
end

RegisterNetEvent('sl-garage:client:SpawnVehicle', function(data)
    local garage = Config.Garages[data.garage]
    local spawnPoint = garage.zones.spawn
    
    -- Check if spawn point is clear
    local clear = IsSpawnPointClear(vector3(spawnPoint.x, spawnPoint.y, spawnPoint.z), 3.0)
    if not clear then
        SLCore.Functions.Notify('Spawn point is blocked!', 'error')
        return
    end
    
    -- Request vehicle spawn
    TriggerServerEvent('sl-garage:server:SpawnVehicle', data.vehicle.plate, {
        x = spawnPoint.x,
        y = spawnPoint.y,
        z = spawnPoint.z,
        w = spawnPoint.w
    })
end) 