# SL Jobs Management System

A comprehensive job management system for the SL-Core framework.

## Features

- Complete employee management
- Job application processing
- Financial management
- Skill progression system
- Paycheck system
- Duty management
- Boss menu interface

## Installation

1. Place the `sl-jobs` folder in your resources directory
2. Import `sql/jobs.sql` into your database
3. Add `ensure sl-jobs` to your server.cfg
4. Configure `config.lua` to your preferences

## Dependencies

- sl-core
- sl-menu
- sl-target
- oxmysql

## Usage

### For Job Managers

1. Access the management interface:
   - Use `/jobmanagement` command
   - Must have appropriate job grade (boss/manager)

2. Employee Management:
   - View all employees
   - Promote/demote employees
   - Fire employees
   - View duty status

3. Application Processing:
   - Review pending applications
   - Accept/reject applications
   - Add notes to applications

4. Financial Management:
   - View society balance
   - Deposit/withdraw funds
   - View transaction history

### For Employees

1. Duty Management:
   - Clock in/out at duty locations
   - View current duty status

2. Skill System:
   - Gain experience while working
   - Level up job-specific skills
   - View skill progression

## Configuration

### Job Setup 