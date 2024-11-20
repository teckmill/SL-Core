fx_version 'cerulean'
game 'gta5'

description 'SL-Dealership - Vehicle Dealership System'
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
    'client/menus.lua',
    'client/displays.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'sl-core',
    'sl-vehicles',
    'sl-garage',
    'sl-menu',
    'PolyZone',
    'oxmysql'
}

lua54 'yes' 