# SL Menu

A modern, flexible, and feature-rich menu system for the SL-Core framework. This resource provides an easy-to-use menu system with multiple menu types, themes, and interactive elements.

## Features

- 🎨 Multiple Menu Types
  - List View (default)
  - Grid View
  - Context Menu View

- 🌈 Theme Support
  - Light Theme (default)
  - Dark Theme
  - Customizable through CSS variables

- 🎯 Interactive Elements
  - Regular Buttons
  - Sliders
  - Checkboxes
  - Input Fields

- ⌨️ Keyboard Navigation
  - Arrow keys for item selection
  - Enter to select/activate
  - Escape to close
  - Auto-scroll to keep selected item visible

- 🎭 Visual Features
  - Smooth animations
  - Modern UI design
  - Visual feedback for interactions
  - FontAwesome icon support
  - Responsive layout

## Installation

1. Ensure you have SL-Core installed and running
2. Copy the `sl-menu` folder to your `resources/[sl]` directory
3. Add `ensure sl-menu` to your `server.cfg`

## Usage

### Basic Menu

```lua
exports['sl-menu']:OpenMenu({
    id = 'my_menu',
    title = 'My Menu',
    description = 'Select an option',
    items = {
        {
            id = 'item1',
            label = 'Option 1',
            icon = 'fas fa-star'
        },
        {
            id = 'item2',
            label = 'Option 2',
            icon = 'fas fa-cog'
        }
    }
})
```

### Menu Types

#### List Menu (Default)
```lua
exports['sl-menu']:OpenMenu({
    id = 'list_menu',
    type = 'list',
    title = 'List Menu',
    items = {
        {
            id = 'item1',
            label = 'List Item 1'
        }
    }
})
```

#### Grid Menu
```lua
exports['sl-menu']:OpenMenu({
    id = 'grid_menu',
    type = 'grid',
    title = 'Grid Menu',
    items = {
        {
            id = 'item1',
            label = 'Grid Item 1',
            icon = 'fas fa-home'
        }
    }
})
```

#### Context Menu
```lua
exports['sl-menu']:OpenMenu({
    id = 'context_menu',
    type = 'context',
    title = 'Context Menu',
    items = {
        {
            id = 'item1',
            label = 'Context Item 1'
        }
    }
})
```

### Interactive Elements

#### Slider
```lua
{
    id = 'volume',
    type = 'slider',
    label = 'Volume',
    min = 0,
    max = 100,
    value = 50
}
```

#### Checkbox
```lua
{
    id = 'toggle',
    type = 'checkbox',
    label = 'Enable Feature',
    checked = true
}
```

#### Input Field
```lua
{
    id = 'name',
    type = 'input',
    label = 'Name',
    placeholder = 'Enter your name'
}
```

### Themes

```lua
-- In your client script
exports['sl-menu']:SetTheme('dark')

-- Or when opening a menu
exports['sl-menu']:OpenMenu({
    id = 'themed_menu',
    theme = 'dark',
    title = 'Dark Theme Menu',
    items = {}
})
```

### Events

#### Client Events
```lua
-- Menu item clicked
AddEventHandler('sl-menu:client:menuItemClicked', function(menuId, itemId, value)
    print('Menu:', menuId, 'Item:', itemId, 'Value:', value)
end)

-- Slider changed
AddEventHandler('sl-menu:client:sliderChanged', function(menuId, itemId, value)
    print('Slider:', itemId, 'Value:', value)
end)

-- Checkbox changed
AddEventHandler('sl-menu:client:checkboxChanged', function(menuId, itemId, checked)
    print('Checkbox:', itemId, 'Checked:', checked)
end)

-- Input submitted
AddEventHandler('sl-menu:client:inputSubmitted', function(menuId, itemId, value)
    print('Input:', itemId, 'Value:', value)
end)
```

### Exports

```lua
-- Open a menu
exports['sl-menu']:OpenMenu(menuData)

-- Close current menu
exports['sl-menu']:CloseMenu()

-- Update menu items
exports['sl-menu']:UpdateMenu(menuId, menuData)

-- Set theme
exports['sl-menu']:SetTheme(theme)

-- Check if menu is open
local isOpen = exports['sl-menu']:IsMenuOpen()

-- Get current menu ID
local menuId = exports['sl-menu']:GetCurrentMenu()
```

## Customization

### CSS Variables

You can customize the appearance by modifying the CSS variables in `html/styles.css`:

```css
:root {
    --menu-bg: #ffffff;
    --menu-text: #333333;
    --menu-border: #eeeeee;
    --menu-hover: #f5f5f5;
    --menu-active: #e0e0e0;
    --menu-disabled: #999999;
    --menu-shadow: rgba(0, 0, 0, 0.1);
    --menu-overlay: rgba(0, 0, 0, 0.5);
    --menu-accent: #4CAF50;
}
```

## Examples

### Character Creation Menu
```lua
exports['sl-menu']:OpenMenu({
    id = 'character_creation',
    title = 'Create Character',
    description = 'Customize your character',
    items = {
        {
            id = 'name',
            type = 'input',
            label = 'Character Name',
            placeholder = 'Enter name'
        },
        {
            id = 'age',
            type = 'slider',
            label = 'Age',
            min = 18,
            max = 90,
            value = 30
        },
        {
            id = 'gender',
            label = 'Gender',
            icon = 'fas fa-user'
        }
    }
})
```

### Settings Menu
```lua
exports['sl-menu']:OpenMenu({
    id = 'settings',
    title = 'Settings',
    theme = 'dark',
    items = {
        {
            id = 'notifications',
            type = 'checkbox',
            label = 'Enable Notifications',
            checked = true
        },
        {
            id = 'volume',
            type = 'slider',
            label = 'Volume',
            min = 0,
            max = 100,
            value = 75
        }
    }
})
```

## License

MIT License - Feel free to use this resource in your server, modify it, and share it with others.

## Credits

Created by the SL-Core Development Team
Icons provided by FontAwesome
