# SL-Ambulance

Advanced EMS system for FiveM servers with wound management, hospital system, and patient records.

## Features

- Complete wound management system
- Hospital bed system with animations
- Patient records and vitals tracking
- Death and revive system
- Treatment interface
- EMS equipment and supplies
- Database integration

## Installation

1. Import `sql/ambulance.sql` into your database
2. Add `ensure sl-ambulance` to your server.cfg
3. Configure settings in `config.lua`
4. Restart your server

## Dependencies

- sl-core
- sl-target
- sl-menu
- PolyZone
- oxmysql

## Usage

### For EMS Personnel

1. Duty Management:
   - Use duty points to clock in/out
   - Access EMS equipment when on duty

2. Patient Treatment:
   - Check vitals
   - Treat wounds
   - Manage medications
   - Access patient records

3. Hospital System:
   - Admit patients
   - Manage hospital beds
   - Track patient status

### For Players

1. Death System:
   - Automatic wound creation
   - Death timer
   - Respawn system

2. Treatment:
   - Receive medical care
   - View personal injuries
   - Access medical records

## Configuration 