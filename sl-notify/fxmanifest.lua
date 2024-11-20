fx_version 'cerulean'
game 'gta5'

description 'SL-Notify - Notification System'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/fonts/*.ttf',
    'html/img/*.svg',
    'html/img/*.png'
}

dependencies {
    'sl-core'
}
