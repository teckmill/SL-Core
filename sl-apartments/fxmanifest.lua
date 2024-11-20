fx_version 'cerulean'
game 'gta5'

description 'SL-Apartments - Advanced Housing System'
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
    'client/interior.lua',
    'client/storage.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/storage.lua'
}

dependencies {
    'sl-core',
    'sl-inventory',
    'PolyZone',
    'oxmysql'
}

lua54 'yes' 