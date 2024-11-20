# SL-Spawn

A modern and feature-rich spawn system for the SL-Core framework. This resource provides a beautiful and intuitive spawn selection interface with support for multiple spawn types, including last location, apartments, hotels, and custom locations.

## Features

- 🎨 Modern and responsive UI design
- 🌍 Multiple spawn types (Last Location, Apartments, Hotels, Custom Locations)
- 📸 Location previews with smooth camera transitions
- 🌤️ Dynamic weather and time display
- 🏠 Apartment integration
- 🏨 Hotel system for new characters
- ⚡ Performance optimized
- 🔧 Highly configurable
- 🌐 Multi-language support
- 🎮 Controller support
- 🎯 Debug mode for development

## Dependencies

- sl-core
- oxmysql

## Installation

1. Ensure you have the required dependencies installed
2. Place the resource in your `resources/[sl]` directory
3. Add `ensure sl-spawn` to your server.cfg
4. Configure the resource in `config.lua`

## Configuration

The resource can be configured through the `config.lua` file:

```lua
Config = {
    Debug = false,
    DefaultSpawn = vector4(195.17, -933.77, 29.7, 144.5),
    SpawnInLastPosition = true,
    
    -- Camera Settings
    StartingCam = vector4(-1355.93, -1487.78, 520.75, 350.84),
    CameraTransitionSpeed = 1.0,
    CameraZoomSpeed = 0.5,
    CameraHeight = 45.0,
    
    -- Spawn Points
    Spawns = {
        ['legion'] = {
            coords = vector4(195.17, -933.77, 29.7, 144.5),
            label = "Legion Square",
            description = "The heart of Los Santos",
            icon = "fas fa-city",
            image = "legion.jpg"
        },
        -- Add more spawn points here
    },
    
    -- UI Settings
    UISettings = {
        blur = true,
        darkMode = false,
        showLocationImages = true,
        showWeather = true,
        showTime = true
    }
}
```

## Usage

### Client Events

```lua
-- Open spawn menu
TriggerEvent('sl-spawn:client:openUI', data)

-- Close spawn menu
TriggerEvent('sl-spawn:client:closeUI')

-- Spawn player at coordinates
TriggerEvent('sl-spawn:client:spawnPlayer', coords)
```

### Server Events

```lua
-- Request spawn data
TriggerServerEvent('sl-spawn:server:requestSpawnData')

-- Notify server of player spawn
TriggerServerEvent('sl-spawn:server:playerSpawned', data)
```

### Exports

```lua
-- Camera controls
exports['sl-spawn']:StartCam()
exports['sl-spawn']:EndCam()
exports['sl-spawn']:SetCamFocus(coords, instant)
exports['sl-spawn']:TransitionToSpawn(coords)
exports['sl-spawn']:IsCamTransitioning()
```

## Customization

### Adding New Spawn Locations

Add new spawn locations in the `config.lua` file:

```lua
Config.Spawns['new_location'] = {
    coords = vector4(x, y, z, heading),
    label = "Location Name",
    description = "Location Description",
    icon = "fas fa-icon-name",
    image = "location.jpg"
}
```

### Adding New Languages

1. Create a new locale file in the `locales` directory
2. Copy the structure from `en.lua`
3. Translate all strings to your language
4. Add the language to the ConVar options

## Development

### Debug Mode

Enable debug mode in `config.lua` to access development commands:

- `/spawndebug` - Open spawn menu
- `/respawn` - Force respawn

### Adding New Features

1. Fork the repository
2. Create a new branch for your feature
3. Implement your changes
4. Test thoroughly
5. Submit a pull request

## Support

For support, join our Discord server or create an issue on GitHub.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

- SL Development Team
- Icons by FontAwesome
- Fonts by Google Fonts
