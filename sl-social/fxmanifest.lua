fx_version 'cerulean'
game 'gta5'

description 'SL-Social - Comprehensive Social System for FiveM'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/database.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/sounds/*.ogg'
}

lua54 'yes'

dependencies {
    'qb-core',
    'oxmysql',
    'sl-core'
}
