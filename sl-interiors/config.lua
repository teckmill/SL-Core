Config = {}

-- General Settings
Config.Debug = false
Config.ShellSpawnDistance = 100.0
Config.FurnitureLimit = 50
Config.EnableFurniture = true

-- Default Offsets
Config.DefaultExitOffset = vector3(0.0, -2.0, 0.0)

-- Required IPLs
Config.RequiredIPLs = {
    'shell_trailer',
    'shell_v16low',
    'shell_v16mid',
    'shell_michael',
    'shell_trevor',
    'shell_franklin',
    'shell_office1',
    'shell_office2',
    'shell_warehouse1',
    'shell_warehouse2'
}

-- Interior Types
Config.InteriorTypes = {
    apartment = {
        label = "Apartment",
        shells = {
            low = {
                label = "Low-End Apartment",
                model = "shell_v16low",
                offset = vector3(0.0, 0.0, 0.0),
                furniture = {
                    {
                        model = "v_16_bed",
                        pos = vector3(2.0, 2.0, 0.0),
                        rot = vector3(0.0, 0.0, 0.0)
                    },
                    {
                        model = "v_16_sofa",
                        pos = vector3(-2.0, 2.0, 0.0),
                        rot = vector3(0.0, 0.0, 180.0)
                    }
                }
            },
            mid = {
                label = "Mid-Range Apartment",
                model = "shell_v16mid",
                offset = vector3(0.0, 0.0, 0.0),
                furniture = {
                    {
                        model = "v_16_bed",
                        pos = vector3(2.5, 2.5, 0.0),
                        rot = vector3(0.0, 0.0, 0.0)
                    },
                    {
                        model = "v_16_sofa",
                        pos = vector3(-2.5, 2.5, 0.0),
                        rot = vector3(0.0, 0.0, 180.0)
                    }
                }
            }
        }
    },
    office = {
        label = "Office",
        shells = {
            small = {
                label = "Small Office",
                model = "shell_office1",
                offset = vector3(0.0, 0.0, 0.0),
                furniture = {
                    {
                        model = "v_corp_offchair",
                        pos = vector3(0.0, 0.0, 0.0),
                        rot = vector3(0.0, 0.0, 0.0)
                    },
                    {
                        model = "v_corp_offdesk",
                        pos = vector3(0.0, 1.0, 0.0),
                        rot = vector3(0.0, 0.0, 0.0)
                    }
                }
            },
            large = {
                label = "Large Office",
                model = "shell_office2",
                offset = vector3(0.0, 0.0, 0.0),
                furniture = {
                    {
                        model = "v_corp_offchair",
                        pos = vector3(0.0, 0.0, 0.0),
                        rot = vector3(0.0, 0.0, 0.0)
                    },
                    {
                        model = "v_corp_offdesk",
                        pos = vector3(0.0, 1.0, 0.0),
                        rot = vector3(0.0, 0.0, 0.0)
                    }
                }
            }
        }
    },
    warehouse = {
        label = "Warehouse",
        shells = {
            small = {
                label = "Small Warehouse",
                model = "shell_warehouse1",
                offset = vector3(0.0, 0.0, 0.0),
                furniture = {}
            },
            large = {
                label = "Large Warehouse",
                model = "shell_warehouse2",
                offset = vector3(0.0, 0.0, 0.0),
                furniture = {}
            }
        }
    }
}

return Config
