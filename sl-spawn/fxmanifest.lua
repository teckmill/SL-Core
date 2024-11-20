fx_version 'cerulean'
game 'gta5'

description 'SL-Spawn - Advanced Spawn System for SL-Core'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/events.lua',
    'client/camera.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js',
    'html/assets/*.png',
    'html/assets/*.jpg'
}

lua54 'yes'

dependencies {
    'sl-core',
    'oxmysql'
}
