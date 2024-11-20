fx_version 'cerulean'
game 'gta5'

description 'SL-Garage - Garage Management System'
version '1.0.0'

dependencies {
    'sl-core',
    'sl-vehicle',
    'sl-menu',
    'PolyZone',
    'oxmysql'
}

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/main.lua',
    'client/menus.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

lua54 'yes'