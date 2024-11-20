fx_version 'cerulean'
game 'gta5'

author 'Sltech Development'
description 'Advanced Payroll Management System for SL-Core Framework'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

dependencies {
    'sl-core',
    'sl-business',
    'oxmysql'
}

lua54 'yes'
