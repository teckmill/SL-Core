local SLCore = exports['sl-core']:GetCoreObject()
local isMenuOpen = false

local function OpenMechanicMenu()
    if isMenuOpen then return end
    isMenuOpen = true
    
    local menu = {
        {
            header = Lang:t('menu.header'),
            icon = 'fas fa-wrench',
            isMenuHeader = true
        },
        {
            header = Lang:t('menu.repair_options'),
            icon = 'fas fa-tools',
            submenu = true,
            subMenus = {
                {
                    header = Lang:t('menu.full_repair'),
                    params = {
                        event = 'sl-mechanics:client:RepairVehicle',
                        args = {
                            type = 'full'
                        }
                    }
                },
                {
                    header = Lang:t('menu.engine_repair'),
                    params = {
                        event = 'sl-mechanics:client:RepairVehicle',
                        args = {
                            type = 'engine'
                        }
                    }
                },
                {
                    header = Lang:t('menu.body_repair'),
                    params = {
                        event = 'sl-mechanics:client:RepairVehicle',
                        args = {
                            type = 'body'
                        }
                    }
                },
                {
                    header = Lang:t('menu.part_repair'),
                    params = {
                        event = 'sl-mechanics:client:OpenPartMenu'
                    }
                }
            }
        },
        {
            header = Lang:t('menu.diagnose'),
            icon = 'fas fa-search',
            params = {
                event = 'sl-mechanics:client:DiagnoseVehicle'
            }
        },
        {
            header = Lang:t('menu.manage_lift'),
            icon = 'fas fa-arrow-up',
            params = {
                event = 'sl-mechanics:client:ToggleLift'
            }
        },
        {
            header = Lang:t('menu.billing'),
            icon = 'fas fa-file-invoice-dollar',
            params = {
                event = 'sl-mechanics:client:BillCustomer'
            }
        },
        {
            header = Lang:t('menu.parts'),
            icon = 'fas fa-cogs',
            params = {
                event = 'sl-mechanics:client:OpenPartsInventory'
            }
        },
        {
            header = Lang:t('menu.close'),
            icon = 'fas fa-times',
            params = {
                event = 'sl-menu:client:closeMenu'
            }
        }
    }
    
    exports['sl-menu']:openMenu(menu)
    isMenuOpen = false
end

local function OpenPartMenu()
    if isMenuOpen then return end
    isMenuOpen = true
    
    local menu = {
        {
            header = Lang:t('menu.part_repair'),
            icon = 'fas fa-cog',
            isMenuHeader = true
        }
    }
    
    for partName, translation in pairs(Lang.parts) do
        menu[#menu + 1] = {
            header = translation,
            params = {
                event = 'sl-mechanics:client:RepairVehicle',
                args = {
                    type = 'part',
                    part = partName
                }
            }
        }
    end
    
    menu[#menu + 1] = {
        header = Lang:t('menu.close'),
        icon = 'fas fa-times',
        params = {
            event = 'sl-menu:client:closeMenu'
        }
    }
    
    exports['sl-menu']:openMenu(menu)
    isMenuOpen = false
end

-- Events
RegisterNetEvent('sl-mechanics:client:OpenMechanicMenu', function()
    OpenMechanicMenu()
end)

RegisterNetEvent('sl-mechanics:client:OpenPartMenu', function()
    OpenPartMenu()
end)

-- Export
exports('OpenMechanicMenu', OpenMechanicMenu)
exports('OpenPartMenu', OpenPartMenu)
