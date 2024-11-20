# sl-menu

A flexible and modern menu system for the SL-Core framework.

## Features

- Clean, modern UI design
- Support for icons (FontAwesome)
- Multiple menu types:
  - Basic list menu
  - Detailed menu with descriptions
  - Menu items with right-aligned text
- Customizable styling
- Keyboard shortcuts
- Event-based architecture
- Responsive design

## Dependencies

- sl-core

## Installation

1. Ensure you have sl-core installed
2. Add this folder to your resources directory
3. Add `ensure sl-menu` to your server.cfg

## Usage

### Client Side

```lua
-- Basic menu
exports['sl-menu']:OpenMenu({
    id = "example_menu",
    title = "Example Menu",
    description = "This is an example menu",
    items = {
        {
            id = "item1",
            title = "Menu Item 1",
            description = "This is item 1",
            icon = "fas fa-user",
            closeOnClick = true
        },
        {
            id = "item2",
            title = "Menu Item 2",
            description = "This is item 2",
            icon = "fas fa-car",
            right = "$500"
        }
    }
})

-- Handle menu item clicks
RegisterNetEvent('sl-menu:client:menuItemClicked', function(menuId, itemId)
    if menuId == "example_menu" then
        if itemId == "item1" then
            -- Handle item 1 click
        elseif itemId == "item2" then
            -- Handle item 2 click
        end
    end
end)
```

### Exports

```lua
-- Open a menu
exports['sl-menu']:OpenMenu(menuData)

-- Close current menu
exports['sl-menu']:CloseMenu()

-- Check if any menu is open
exports['sl-menu']:IsMenuOpen()
```

### Keyboard Controls

- `BACK` key (default) - Close current menu
- Can be changed in client/main.lua using RegisterKeyMapping

## Styling

The menu appearance can be customized by modifying the `html/styles.css` file.

## Events

### Client Events

- `sl-menu:client:menuItemClicked` - Triggered when a menu item is clicked
  - Parameters: menuId, itemId

## Contributing

1. Fork the repository
2. Create a new branch for your feature
3. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Credits

Created by SL Development for the SL-Core framework.
