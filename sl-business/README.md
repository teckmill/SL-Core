# SL Business Management System

A comprehensive business management system for FiveM roleplay servers, providing advanced features for business ownership, employee management, and financial operations.

## 🌟 Features

### Business Management
- Multiple business types (Restaurant, Retail Shop, Auto Repair)
- Business ownership and licensing
- Location-based business zones
- Business reputation system
- Customer AI and foot traffic
- Business events and promotions

### Employee Management
- Employee hiring and firing
- Role-based permissions
- Wage management
- Shift scheduling
- Performance tracking
- Integration with sl-jobs

### Financial System
- Business bank accounts
- Loans and financing
- Insurance plans
- Transaction tracking
- Integration with sl-banking
- Tax system

### Inventory Management
- Stock management
- Automatic restocking
- Item degradation
- Integration with sl-inventory
- Storage upgrades

### Business Analytics
- Revenue tracking
- Customer analytics
- Employee performance
- Business reputation
- Financial reports

## 📋 Dependencies

- sl-core: Latest version
- sl-banking: Latest version
- sl-jobs: Latest version
- sl-inventory: Latest version
- sl-menu: Latest version
- sl-target: Latest version
- oxmysql: ^1.9.0

## 🛠️ Installation

1. **Resource Setup**
   ```bash
   # Clone the resource to your resources folder
   git clone https://github.com/SL-Core/sl-business [sl]/sl-business

   # Ensure proper folder structure
   ensure [sl]/sl-business
   ```

2. **Database Setup**
   ```sql
   -- Import the SQL files in order:
   1. sql/schema.sql
   ```

3. **Configuration**
   - Edit `config.lua` to match your server's needs
   - Configure business types and locations
   - Adjust financial settings
   - Set up employee parameters
   - Configure inventory settings

## ⚙️ Configuration

### Business Types
```lua
Config.BusinessTypes = {
    restaurant = {
        label = 'Restaurant',
        requiredLicense = 'business.food',
        basePrice = 150000,
        maxEmployees = 15,
        maxStorage = 1000,
        upgrades = {
            kitchen = {
                levels = 3,
                basePrice = 25000,
                benefits = {
                    productionSpeed = {0.1, 0.2, 0.3},
                    quality = {0.1, 0.2, 0.3}
                }
            }
            -- More in config.lua
        }
    }
    -- More business types in config.lua
}
```

## 🎮 Usage

### Player Commands
- `/createbusiness [type] [name]` - Create a new business
- `/managebusiness` - Open business management menu
- `/hire [id]` - Hire an employee
- `/fire [id]` - Fire an employee
- `/setpay [id] [amount]` - Set employee wage
- `/businessbalance` - Check business balance

### Admin Commands
- `/givebusinesslicense [id] [type]` - Give business license
- `/revokebusinesslicense [id] [type]` - Revoke business license
- `/setbusinessfunds [id] [amount]` - Set business funds
- `/businessadmin` - Open admin panel

## 🔧 API Reference

### Server Events
```lua
-- Create new business
TriggerEvent('sl-business:server:createBusiness', {
    type = 'restaurant',
    name = 'My Restaurant',
    owner = 'PLAYER_ID'
})

-- Process business transaction
TriggerEvent('sl-business:server:processTransaction', {
    business = 'BUSINESS_ID',
    type = 'sale',
    amount = 1000
})
```

### Client Events
```lua
-- Open business menu
TriggerEvent('sl-business:client:openMenu')

-- Open employee management
TriggerEvent('sl-business:client:manageEmployees')
```

### Exports
```lua
-- Get business details
exports['sl-business']:getBusiness(businessId)

-- Get employee list
exports['sl-business']:getEmployees(businessId)
```

## 🔒 Security Features

1. **Transaction Validation**
   - Server-side verification
   - Anti-cheat measures
   - Rate limiting
   - Audit logging

2. **Permission System**
   - Role-based access
   - Owner permissions
   - Employee permissions
   - Admin oversight

## 🎯 Performance

- Optimized database queries
- Efficient caching system
- Minimal resource usage
- Regular cleanup routines

## 🔍 Troubleshooting

### Common Issues

1. **Database Connection**
   ```lua
   -- Check MySQL connection
   MySQL.ready(function()
       print('Database connected')
   end)
   ```

2. **Business Creation Issues**
   - Verify player has required license
   - Check available funds
   - Validate business name
   - Check zone restrictions

3. **Employee Management**
   - Verify employment status
   - Check wage limits
   - Validate permissions
   - Review shift logs

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 Support

For support, please:
1. Check the documentation
2. Review common issues
3. Contact support team
4. Open a GitHub issue

## 🔄 Updates

Stay updated with the latest changes:
- Follow our GitHub repository
- Join our Discord community
- Subscribe to notifications

---

Created with ❤️ by SL-Core Team
