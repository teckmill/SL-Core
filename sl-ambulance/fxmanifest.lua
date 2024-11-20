fx_version 'cerulean'
game 'gta5'

description 'SL-Ambulance - Advanced EMS System'
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
    'client/wounds.lua',
    'client/hospital.lua',
    'client/dead.lua',
    'client/objects.lua',
    'client/job.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/wounds.lua',
    'server/hospital.lua'
}

dependencies {
    'sl-core',
    'sl-target',
    'sl-menu',
    'PolyZone',
    'oxmysql'
}

lua54 'yes' 