# SL-Core Framework

A modern, lightweight, and extensible framework for FiveM servers.

## Features

- Player Management System
- Money & Banking System
- Job System
- Gang System
- Inventory System
- Vehicle Management
- Database Integration
- Notification System
- Callback System

## Dependencies

- oxmysql

## Installation

1. Import `slcore.sql` into your database
2. Ensure you have oxmysql installed
3. Add the following to your server.cfg:
```cfg
ensure oxmysql
ensure sl-core
```

## Usage

To use SL-Core in your resources:

```lua
local SLCore = exports['sl-core']:GetCoreObject()
```

## Configuration

All configuration can be found in `config.lua`. Make sure to adjust settings according to your server's needs.

## Events

### Client Events
- `sl-core:client:updatePlayerData` - Updates player data
- `sl-core:client:moneyChange` - Triggered when player's money changes

### Server Events
- `sl-core:server:triggerCallback` - Used for server callbacks

## Functions

### Client Functions
- `SLCore.Functions.GetPlayerData()`
- `SLCore.Functions.Notify()`
- `SLCore.Functions.DrawText()`
- `SLCore.Functions.TriggerCallback()`

### Server Functions
- `SLCore.Functions.CreatePlayer()`
- `SLCore.Functions.AddMoney()`
- `SLCore.Functions.SetJob()`
- `SLCore.Functions.SetGang()`

## Contributing

Feel free to submit pull requests and report issues.

## License

This project is licensed under the MIT License.
