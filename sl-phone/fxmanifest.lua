fx_version 'cerulean'
game 'gta5'

description 'SL Phone - Advanced Phone System'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    '@sl-core/client/wrapper.lua',
    'client/main.lua',
    'client/animation.lua',
    'client/apps/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@sl-core/server/wrapper.lua',
    'server/main.lua',
    'server/apps/*.lua'
}

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/fonts/*.ttf',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/img/*.svg',
    'html/sounds/*.ogg'
}

dependencies {
    'sl-core',
    'sl-menu',
    'sl-input',
    'oxmysql'
}

lua54 'yes'
