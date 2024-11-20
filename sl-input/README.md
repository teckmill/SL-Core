# sl-input

A flexible input dialog system for the SL-Core framework.

## Features

- Multiple input types supported:
  - Text input
  - Number input (with min/max values)
  - Select dropdown
  - Textarea
- Modern, clean UI design
- Easy to integrate with other resources
- Fully customizable styling
- Responsive design

## Dependencies

- sl-core

## Installation

1. Ensure you have sl-core installed
2. Add this folder to your resources directory
3. Add `ensure sl-input` to your server.cfg

## Usage

### Client Side

```lua
-- Basic text input
exports['sl-input']:ShowInput({
    type = "text",
    title = "Player ID",
    text = "Enter the player ID",
    placeholder = "1-999"
})

-- Number input with min/max
exports['sl-input']:ShowInput({
    type = "number",
    title = "Amount",
    text = "Enter amount to withdraw",
    placeholder = "0-1000",
    min = 0,
    max = 1000
})

-- Select dropdown
exports['sl-input']:ShowInput({
    type = "select",
    title = "Select Vehicle",
    text = "Choose a vehicle to spawn",
    options = {
        { value = "adder", text = "Adder" },
        { value = "zentorno", text = "Zentorno" }
    }
})

-- Textarea input
exports['sl-input']:ShowInput({
    type = "textarea",
    title = "Message",
    text = "Enter your message",
    placeholder = "Type your message here..."
})
```

### Event Handling

```lua
RegisterNetEvent('sl-input:client:submitInput', function(response)
    if response then
        -- Handle the input response
        print("Input received:", response)
    end
end)
```

## Configuration

The input dialog's appearance can be customized by modifying the `html/styles.css` file.

## Contributing

1. Fork the repository
2. Create a new branch for your feature
3. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Credits

Created by SL Development for the SL-Core framework.
