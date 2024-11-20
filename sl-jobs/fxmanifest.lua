fx_version 'cerulean'
game 'gta5'

description 'SL-Jobs - Advanced Job Management System'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/*'
}
