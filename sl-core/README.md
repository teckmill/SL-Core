# SL-Core Framework

A powerful and modular FiveM framework designed for building immersive roleplay servers.

## Features

- Complete player management system
- Job and gang system
- Inventory system
- Vehicle management
- Money management (cash, bank, crypto)
- Admin commands
- Extensive configuration options
- Localization support
- Modern UI with notifications
- Database integration with MySQL

## Dependencies

- [oxmysql](https://github.com/overextended/oxmysql)
- FiveM/CFX server
- MySQL server

## Installation

1. Install the required dependencies
2. Import `slcore.sql` into your database
3. Add the following to your `server.cfg`:

```cfg
ensure oxmysql
ensure sl-core
```

4. Configure the framework in `config.lua`
5. Start your server

## Configuration

The framework can be configured through various files:

- `config.lua`: Main configuration file
- `shared/jobs.lua`: Job configurations
- `shared/gangs.lua`: Gang configurations
- `shared/items.lua`: Item definitions
- `shared/vehicles.lua`: Vehicle configurations
- `shared/weapons.lua`: Weapon configurations
- `shared/locations.lua`: Location definitions

## Documentation

For detailed documentation on functions, events, and exports, please refer to our [Wiki](link-to-wiki).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
