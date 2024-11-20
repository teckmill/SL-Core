fx_version 'cerulean'
game 'gta5'

description 'SL-Inventory - Advanced Inventory System'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/functions.lua',
    'client/drops.lua',
    'client/shops.lua',
    'client/trunk.lua',
    'client/glovebox.lua',
    'client/weapons.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/functions.lua',
    'server/drops.lua',
    'server/shops.lua',
    'server/weapons.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/img/*.png',
    'html/img/*.jpg'
}

lua54 'yes'

dependencies {
    'sl-core',
    'oxmysql'
}
