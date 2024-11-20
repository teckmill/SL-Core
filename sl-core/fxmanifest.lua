fx_version 'cerulean'
game 'gta5'

description 'SL-Core - Core resource for the SL Framework'
version '1.0.0'

shared_scripts {
    'shared/locale.lua',
    'locale/en.lua',
    'shared/main.lua',
    'shared/items.lua',
    'shared/jobs.lua',
    'shared/vehicles.lua',
    'shared/gangs.lua',
    'shared/weapons.lua',
    'shared/locations.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/functions.lua',
    'client/loops.lua',
    'client/events.lua',
    'client/drawtext.lua',
    'client/vehicle.lua',
    'client/inventory.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/functions.lua',
    'server/player.lua',
    'server/events.lua',
    'server/commands.lua',
    'server/debug.lua',
    'server/exports.lua',
    'server/inventory.lua',
    'server/vehicle.lua',
    'server/permissions.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js'
}

dependencies {
    'oxmysql',
    'progressbar'
}

lua54 'yes'
