# sl-target

A powerful and flexible targeting system for the SL-Core framework.

## Features

- Modern and intuitive targeting interface
- Support for entities, models, bones, and zones
- Job-based access control
- Customizable targeting options
- Performance optimized
- Easy to integrate with other resources
- Comprehensive configuration options
- Multi-language support

## Dependencies

- sl-core

## Installation

1. Ensure you have sl-core installed
2. Add this folder to your resources directory
3. Add `ensure sl-target` to your server.cfg

## Usage

### Client Side

```lua
-- Add target for a specific model
exports['sl-target']:AddTargetModel('prop_atm_01', {
    {
        type = "client",
        event = "sl-banking:client:openATM",
        icon = "fas fa-credit-card",
        label = "Use ATM"
    }
}, 2.0)

-- Add target for an entity
exports['sl-target']:AddTargetEntity(entity, {
    {
        type = "client",
        event = "sl-shops:client:openShop",
        icon = "fas fa-shopping-cart",
        label = "Open Shop",
        job = "police" -- Optional job restriction
    }
}, 3.0)

-- Add target zone
exports['sl-target']:AddTargetZone("police_duty", vector3(441.7989, -982.0529, 30.67834), 1.0, 1.0, {
    {
        type = "client",
        event = "sl-policejob:client:toggleDuty",
        icon = "fas fa-sign-in-alt",
        label = "Toggle Duty",
        job = "police"
    }
}, {
    heading = 11.0,
    minZ = 29.67834,
    maxZ = 31.67834
})
```

### Exports

```lua
-- Entity targeting
exports['sl-target']:AddTargetEntity(entity, options, distance)
exports['sl-target']:RemoveTargetEntity(entity)

-- Model targeting
exports['sl-target']:AddTargetModel(models, options, distance)
exports['sl-target']:RemoveTargetModel(models)

-- Bone targeting
exports['sl-target']:AddTargetBone(bones, options, distance)
exports['sl-target']:RemoveTargetBone(bones)

-- Zone targeting
exports['sl-target']:AddTargetZone(name, coords, length, width, options, targetoptions)
exports['sl-target']:RemoveTargetZone(name)
```

### Events

#### Client Events
- `sl-target:client:syncTargets` - Syncs targets across all clients
- `sl-target:client:reloadTargets` - Reloads all targets

#### Server Events
- `sl-target:server:syncTargets` - Server-side target synchronization

### Configuration

The targeting system can be configured through the `config.lua` file:

```lua
Config.Debug = false -- Enable debug mode
Config.DefaultDistance = 2.5 -- Default interaction distance
Config.MaxDistance = 10.0 -- Maximum targeting distance
Config.OpenKey = 'LMENU' -- Key to toggle targeting mode
Config.DisableInVehicle = true -- Disable targeting while in vehicle
```

## Contributing

1. Fork the repository
2. Create a new branch for your feature
3. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Credits

Created by SL Development for the SL-Core framework.
