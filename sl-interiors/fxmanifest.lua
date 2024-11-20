fx_version 'cerulean'
game 'gta5'

author 'SL Framework'
description 'Interior Management System for SL Framework'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/shells.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'sl-core',
    'oxmysql'
}

lua54 'yes'
