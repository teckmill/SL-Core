# SL-Inventory

A comprehensive and modern inventory system for FiveM roleplay servers, built for the SL-Core framework.

## 🌟 Features

### Core Features
- Modern, responsive UI with dark/light theme support
- Drag and drop functionality
- Item stacking and splitting
- Weight-based system
- Durability system
- Hotbar support (5 slots)
- Context menu for item actions
- Notifications system

### Inventory Types
- Player inventory
- Vehicle trunk
- Vehicle glovebox
- Storage units
- Shop system
- Crafting stations
- Drop system

### Item Management
- Item categories
- Item descriptions
- Item images
- Item weights
- Item durability
- Item usage animations
- Custom item actions

### Technical Features
- Optimized performance
- Server-side validation
- Secure item handling
- Database integration
- Event-driven architecture
- Extensive configuration options
- Multi-language support

## 📋 Dependencies

- SL-Core Framework
- oxmysql
- jQuery v3.6.0
- jQuery UI v1.13.2
- Font Awesome 6.4.0
- jQuery Context Menu v2.9.2

## 🚀 Installation

1. Ensure you have the SL-Core framework installed
2. Clone this repository into your `resources/[sl]` folder
3. Import the provided SQL file into your database
4. Add `ensure sl-inventory` to your server.cfg
5. Configure the resource in `config.lua`

## ⚙️ Configuration

The inventory system is highly configurable through several files:

### config.lua
- General settings
- Weight limits
- Slot configurations
- Item definitions
- Shop configurations
- Crafting recipes

### html/config.js
- UI settings
- Theme options
- Sound effects
- Animations
- Hotkey bindings
- Notification settings

## 🎮 Usage

### Player Commands
- `/inventory` - Open inventory
- `/giveitem [id] [item] [amount]` - Give item to player
- `/removeitem [item] [amount]` - Remove item from inventory
- `/clearinventory` - Clear inventory
- `/nearby` - View nearby dropped items

### Exports

```lua
-- Server exports
exports['sl-inventory']:AddItem(source, item, amount, slot, info)
exports['sl-inventory']:RemoveItem(source, item, amount, slot)
exports['sl-inventory']:GetItemBySlot(source, slot)
exports['sl-inventory']:GetItemByName(source, item)
exports['sl-inventory']:GetTotalWeight(items)

-- Client exports
exports['sl-inventory']:HasItem(item, amount)
exports['sl-inventory']:UseItem(item)
exports['sl-inventory']:GetItemInfo(item)
```

### Events

```lua
-- Server events
RegisterNetEvent('sl-inventory:server:UseItem')
RegisterNetEvent('sl-inventory:server:GiveItem')
RegisterNetEvent('sl-inventory:server:SetInventoryData')

-- Client events
RegisterNetEvent('sl-inventory:client:ItemBox')
RegisterNetEvent('sl-inventory:client:UpdateInventory')
RegisterNetEvent('sl-inventory:client:CloseInventory')
```

## 🎨 Customization

### Adding Custom Items

```lua
QBCore.Functions.AddItem('itemname', {
    name = 'itemname',
    label = 'Item Label',
    weight = 1,
    type = 'item',
    image = 'itemname.png',
    unique = false,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'Item description'
})
```

### Custom Item Actions

```lua
QBCore.Functions.CreateUseableItem('itemname', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    -- Your custom item logic here
end)
```

## 🔧 Development

### File Structure
```
sl-inventory/
├── client/
│   ├── main.lua
│   └── inventory.lua
├── server/
│   ├── main.lua
│   ├── crafting.lua
│   └── shops.lua
├── html/
│   ├── index.html
│   ├── styles.css
│   ├── config.js
│   └── app.js
├── config.lua
├── fxmanifest.lua
└── README.md
```

### Contributing
1. Fork the repository
2. Create a new branch
3. Make your changes
4. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Support

For support, join our Discord server or create an issue in the GitHub repository.

## 📜 Changelog

### v1.0.0
- Initial release
- Modern UI implementation
- Core inventory functionality
- Vehicle inventory support
- Shop system
- Crafting system
- Item durability
- Weight system
- Hotbar functionality

## 🙏 Credits

- SL-Core Team
- FiveM Community
- Contributors

## 🔗 Links

- [Discord](https://discord.gg/your-discord)
- [Documentation](https://docs.your-website.com)
- [Bug Reports](https://github.com/your-repo/issues)
