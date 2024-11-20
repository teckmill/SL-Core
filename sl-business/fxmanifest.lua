fx_version 'cerulean'
game 'gta5'

description 'SL-Business - Advanced Business Management System'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/menu.lua',
    'client/employees.lua',
    'client/inventory.lua',
    'client/upgrades.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/employees.lua',
    'server/finances.lua',
    'server/inventory.lua',
    'server/upgrades.lua'
}

dependencies {
    'sl-core',
    'sl-banking',
    'sl-jobs',
    'sl-inventory',
    'sl-menu',
    'sl-target',
    'oxmysql'
}

provide 'sl-business'

lua54 'yes'
