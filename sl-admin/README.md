# SL Admin System

A comprehensive administration system for FiveM servers using the SL Framework. This advanced admin menu provides a complete suite of tools for server management, player control, and development assistance.

## 🌟 Features

### 👥 Player Management
- Advanced Ban/Kick System with Duration Control
- Real-time Player Spectating
- Player Reports & Handling System
- Player Freeze/Unfreeze
- Teleport Controls (Goto/Bring)
- Comprehensive Player Information
- Inventory Access & Item Management
- Player Revival & Healing
- Player State Management

### 🛠️ Admin Tools
- NoClip with Speed Controls
- God Mode Toggle
- Invisibility Toggle
- Advanced Vehicle Spawner
- Vehicle Modifications & Repairs
- Weather & Time Control
- Developer Tools & Debugging

### 🔧 Developer Tools
- Coordinate Display
- Entity Information
- Vehicle Data
- Performance Metrics
- Debug Mode
- Resource Management

### 📊 Logging System
- Comprehensive Discord Integration
- Database Logging
- Detailed Action Tracking
- Report Management
- Admin Activity Monitoring

## 📦 Installation

1. Required Dependencies:
   ```
   - sl-core
   - sl-menu
   - sl-input
   - oxmysql
   ```

2. Database Setup:
   ```sql
   mysql -u yourusername -p yourdatabase < sql/tables.sql
   ```

3. Discord Integration:
   ```lua
   -- config.lua
   Config.DiscordLogChannels = {
       ['bans'] = 'your-webhook-url',
       ['kicks'] = 'your-webhook-url',
       ['admin'] = 'your-webhook-url',
       ['reports'] = 'your-webhook-url'
   }
   ```

4. Server Configuration:
   ```cfg
   # server.cfg
   ensure sl-core
   ensure sl-menu
   ensure sl-input
   ensure sl-admin
   ```

## ⚙️ Configuration

### Admin Ranks
```lua
Config.AdminRanks = {
    ['user'] = 0,
    ['helper'] = 1,
    ['moderator'] = 2,
    ['admin'] = 3,
    ['superadmin'] = 4,
    ['owner'] = 5
}
```

### Permission System
```lua
Config.Permissions = {
    ['menu'] = 1,        -- helper and above
    ['kick'] = 2,        -- moderator and above
    ['ban'] = 3,         -- admin and above
    ['developer'] = 4,   -- superadmin and above
    -- See config.lua for full list
}
```

## 🎮 Commands

### Player Management
- `/admin` - Open admin menu
- `/kick <id> <reason>` - Kick player
- `/ban <id> <duration> <reason>` - Ban player
- `/unban <identifier>` - Unban player
- `/freeze <id>` - Toggle player freeze
- `/bring <id>` - Bring player
- `/goto <id>` - Go to player
- `/spectate <id>` - Spectate player

### Admin Tools
- `/noclip` - Toggle noclip
- `/god` - Toggle god mode
- `/invis` - Toggle invisibility
- `/car <model>` - Spawn vehicle
- `/dv` - Delete vehicle
- `/fix` - Fix vehicle
- `/weather <type>` - Set weather
- `/time <hour>` - Set time
- `/coords` - Toggle coordinate display

### Report System
- `/report <message>` - Submit report
- `/reports` - View reports
- `/closereport <id>` - Close report

## 🔄 Events

### Client Events
```lua
-- Player Management
'sl-admin:client:ToggleNoclip'
'sl-admin:client:ToggleGodmode'
'sl-admin:client:ToggleInvisible'
'sl-admin:client:Revive'
'sl-admin:client:Heal'

-- Vehicle Management
'sl-admin:client:SpawnVehicle'
'sl-admin:client:DeleteVehicle'
'sl-admin:client:FixVehicle'
'sl-admin:client:ModifyVehicle'

-- World Management
'sl-admin:client:SetWeather'
'sl-admin:client:SetTime'
'sl-admin:client:ToggleBlackout'

-- Developer Tools
'sl-admin:client:ToggleDevMode'
'sl-admin:client:ShowCoords'
'sl-admin:client:EntityInfo'
```

### Server Events
```lua
-- Player Management
'sl-admin:server:KickPlayer'
'sl-admin:server:BanPlayer'
'sl-admin:server:UnbanPlayer'
'sl-admin:server:FreezePlayer'
'sl-admin:server:RevivePlayer'

-- Item Management
'sl-admin:server:GiveItem'
'sl-admin:server:RemoveItem'

-- Logging
'sl-admin:server:LogAction'
'sl-admin:server:LogToDiscord'
```

## 📊 Database Schema

### Bans Table
```sql
CREATE TABLE `bans` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) DEFAULT NULL,
    `license` varchar(50) DEFAULT NULL,
    `discord` varchar(50) DEFAULT NULL,
    `ip` varchar(50) DEFAULT NULL,
    `reason` text DEFAULT NULL,
    `expire` int(11) DEFAULT NULL,
    `bannedby` varchar(50) DEFAULT NULL,
    `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`)
);
```

### Admin Logs
```sql
CREATE TABLE `admin_logs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `type` varchar(50) NOT NULL,
    `admin` varchar(50) NOT NULL,
    `target` varchar(50) DEFAULT NULL,
    `action` varchar(255) NOT NULL,
    `data` text DEFAULT NULL,
    `timestamp` int(11) NOT NULL,
    PRIMARY KEY (`id`)
);
```

## 📝 License

This project is licensed under the MIT License with additional terms - see the [LICENSE](LICENSE) file for details.

## 🤝 Support

For support:
- Create an issue on our GitHub repository
- Join our Discord community
- Check our documentation

## 🔄 Updates

Stay updated with the latest features and improvements:
- Follow our GitHub repository
- Join our Discord for announcements
- Check the releases page for changelogs

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines for details.
