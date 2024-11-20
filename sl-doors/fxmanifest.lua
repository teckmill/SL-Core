fx_version 'cerulean'
game 'gta5'

description 'SL Doors - Advanced Door Management System'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    '@sl-core/client/wrapper.lua',
    '@sl-core/shared/utils.lua',
    'client/main.lua',
    'client/utils.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@sl-core/shared/utils.lua',
    'server/main.lua',
    'server/utils.lua'
}

dependencies {
    'sl-core',
    'sl-menu',
    'sl-input',
    'oxmysql'
}
