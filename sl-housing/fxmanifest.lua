fx_version 'cerulean'
game 'gta5'

description 'SL-Housing - Advanced Housing System for SL-Core Framework'
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
    'client/houses.lua',
    'client/furniture.lua',
    'client/interactions.lua',
    'client/shells.lua',
    'client/utils.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/houses.lua',
    'server/furniture.lua',
    'server/interactions.lua',
    'server/utils.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/config.js',
    'html/app.js',
    'html/sounds/*.ogg',
    'html/images/*.png',
    'html/images/*.jpg'
}

lua54 'yes'

dependencies {
    'sl-core',
    'oxmysql',
    'PolyZone'
}
