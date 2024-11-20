fx_version 'cerulean'
game 'gta5'

description 'SL-Vehicle - Advanced Vehicle Management System'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/functions.lua',
    'client/racing.lua',
    'client/tuning.lua',
    'client/damage.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/functions.lua',
    'server/racing.lua',
    'server/tuning.lua'
}

dependencies {
    'sl-core',
    'sl-garage',
    'sl-fuel',
    'oxmysql'
}

provide 'sl-vehicle'

lua54 'yes'
