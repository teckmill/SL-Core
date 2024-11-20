fx_version 'cerulean'
game 'gta5'

description 'SL-Police - Advanced Police System'
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
    'client/interactions.lua',
    'client/evidence.lua',
    'client/radar.lua',
    'client/mdt.lua',
    'client/objects.lua',
    'client/tracker.lua',
    'client/fingerprint.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/evidence.lua',
    'server/mdt.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/img/*.png'
}

dependencies {
    'sl-core',
    'sl-inventory',
    'sl-menu',
    'sl-target',
    'PolyZone',
    'oxmysql'
}

lua54 'yes' 