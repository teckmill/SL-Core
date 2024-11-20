fx_version 'cerulean'
game 'gta5'

description 'SL-Fuel - Advanced Vehicle Fuel Management System'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    '@sl-core/shared/utils.lua',
    'client/main.lua',
    'client/nozzle.lua',
    'client/stations.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@sl-core/shared/utils.lua',
    'server/main.lua'
}

lua54 'yes'
