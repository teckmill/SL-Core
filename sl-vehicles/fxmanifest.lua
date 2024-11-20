fx_version 'cerulean'
game 'gta5'

description 'SL-Vehicles - Advanced Vehicle Management System'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/main.lua',
    'client/functions.lua',
    'client/damage.lua',
    'client/fuel.lua',
    'client/keys.lua',
    'client/racing.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/functions.lua',
    'server/ownership.lua',
    'server/keys.lua'
}

dependencies {
    'sl-core',
    'sl-inventory',
    'PolyZone',
    'oxmysql'
}

lua54 'yes' 