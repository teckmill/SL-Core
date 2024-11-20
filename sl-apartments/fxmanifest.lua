fx_version 'cerulean'
game 'gta5'

author 'SL Framework'
description 'Apartment system for SL Framework'
version '1.0.0'

shared_scripts {
    'locales/en.lua',
    'config.lua'
}

client_scripts {
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
    'oxmysql'
}

lua54 'yes'