fx_version 'cerulean'
game 'gta5'

description 'SL-Target - Advanced Targeting System for SL-Core'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/functions.lua'
}

server_scripts {
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js',
    'html/eye.png'
}

lua54 'yes'

dependency 'sl-core'
