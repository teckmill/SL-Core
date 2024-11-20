fx_version 'cerulean'
game 'gta5'

description 'SL-Database - Database Management System'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

dependencies {
    'sl-core',
    'oxmysql'
}
