fx_version 'cerulean'
game 'gta5'

description 'SL-Clothing - Advanced Character Customization'
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
    'client/functions.lua',
    'client/camera.lua',
    'client/shops.lua',
    'client/outfits.lua',
    'client/tattoos.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/outfits.lua'
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
    'sl-target',
    'PolyZone',
    'oxmysql'
}

lua54 'yes' 