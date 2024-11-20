# SL Banking System

A comprehensive banking system for FiveM roleplay servers, providing advanced financial mechanics and a modern banking experience.

## 🌟 Features

### Account Management
- Multiple account types (Personal, Business, Savings, Credit)
- Secure PIN-based access
- Real-time balance updates
- Account status monitoring
- Detailed transaction history

### Transaction System
- Deposits and withdrawals
- Inter-account transfers
- Wire transfers
- Transaction logging
- Server-side validation

### Investment Platform
- Stock market investments
- Cryptocurrency trading
- Government bonds
- Dynamic return rates
- Investment portfolio tracking

### Loan System
- Multiple loan types:
  - Personal loans
  - Business loans
  - Mortgages
- Credit score based interest rates
- Flexible repayment terms
- Automatic payment processing

### Credit Score System
- Dynamic score calculation
- Payment history tracking
- Credit utilization monitoring
- Score impact on loan terms
- Credit history reporting

## 📋 Dependencies

- sl-core: Latest version
- oxmysql: ^1.9.0
- sl-target: Latest version

## 🛠️ Installation

1. **Resource Setup**
   ```bash
   # Clone the resource to your resources folder
   git clone https://github.com/SL-Core/sl-banking [sl]/sl-banking

   # Ensure proper folder structure
   ensure [sl]/sl-banking
   ```

2. **Database Setup**
   ```sql
   -- Import the SQL files in order:
   1. sql/schema.sql
   2. sql/functions.sql
   ```

3. **Configuration**
   - Edit `config.lua` to match your server's needs
   - Configure ATM and bank locations
   - Adjust account limits and settings
   - Set up investment parameters
   - Configure loan terms

## ⚙️ Configuration

### Account Types
```lua
Config.AccountTypes = {
    personal = {
        maxBalance = 999999999,
        minBalance = -1000,
        dailyLimit = 50000
    },
    business = {
        maxBalance = 99999999999,
        minBalance = -10000,
        dailyLimit = 500000
    }
    -- More in config.lua
}
```

### ATM Settings
```lua
Config.ATMModels = {
    'prop_atm_01',
    'prop_atm_02',
    'prop_atm_03',
    'prop_fleeca_atm'
}

Config.ATMLimits = {
    maxWithdrawal = 5000,
    maxDeposit = 10000
}
```

## 🎮 Usage

### Player Commands
- `/createaccount [type] [pin]` - Create a new bank account
- `/transfer [account] [amount]` - Transfer money
- `/balance` - Check account balance
- `/statement` - View transaction history

### Admin Commands
- `/freezeaccount [id]` - Freeze an account
- `/setbalance [id] [amount]` - Set account balance
- `/bankadmin` - Open admin panel

## 🔧 API Reference

### Server Events
```lua
-- Create new account
TriggerEvent('sl-banking:server:createAccount', {
    type = 'personal',
    pin = '1234'
})

-- Process transaction
TriggerEvent('sl-banking:server:processTransaction', {
    account = 'ACC123',
    type = 'deposit',
    amount = 1000
})
```

### Client Events
```lua
-- Open banking interface
TriggerEvent('sl-banking:client:openBank')

-- Open ATM interface
TriggerEvent('sl-banking:client:openATM')
```

### Exports
```lua
-- Get account details
exports['sl-banking']:getAccount(accountNumber)

-- Get transaction history
exports['sl-banking']:getTransactions(accountNumber)
```

## 🔒 Security Features

1. **Transaction Validation**
   - Server-side verification
   - Double-entry accounting
   - Transaction limits
   - Anti-cheat measures

2. **Account Security**
   - PIN protection
   - Session management
   - Login attempt limits
   - Activity logging

3. **Data Protection**
   - Encrypted communications
   - Secure data storage
   - Regular backups
   - Audit trails

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

2. **Transaction Errors**
   - Verify account balance
   - Check transaction limits
   - Review error logs

3. **UI Issues**
   - Clear browser cache
   - Check NUI focus
   - Verify resource state

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
