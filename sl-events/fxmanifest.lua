fx_version 'cerulean'
game 'gta5'

description 'SL-Events - Event Management System'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

server_scripts {
    'server/*.lua'
}

client_scripts {
    'client/*.lua'
}

dependencies {
    'sl-core'
}
