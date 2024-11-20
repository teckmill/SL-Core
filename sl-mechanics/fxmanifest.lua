fx_version 'cerulean'
game 'gta5'

description 'SL-Mechanics - Advanced Vehicle Repair System'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    '@sl-core/shared/utils.lua',
    'client/main.lua',
    'client/menu.lua',
    'client/repairs.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@sl-core/shared/utils.lua',
    'server/main.lua'
}

lua54 'yes'
