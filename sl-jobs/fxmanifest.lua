fx_version 'cerulean'
game 'gta5'

description 'SL-Jobs - Advanced Job Management System'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    'client/main.lua',
    'client/duties.lua',
    'client/missions.lua',
    'client/bossmenu.lua',
    'client/garage.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/paycheck.lua',
    'server/missions.lua',
    'server/society.lua'
}

dependencies {
    'sl-core',
    'sl-menu',
    'sl-target',
    'PolyZone',
    'oxmysql'
}

lua54 'yes'
