fx_version 'cerulean'
game 'gta5'

description 'SL-Inventory - Modern Inventory System for SL-Core'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/inventory.lua',
    'client/hotbar.lua',
    'client/drops.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/inventory.lua',
    'server/drops.lua',
    'server/crafting.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js',
    'html/assets/*.png',
    'html/assets/*.jpg',
    'html/assets/*.svg'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
