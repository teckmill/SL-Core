fx_version 'cerulean'
game 'gta5'

author 'Sltech Development'
description 'Advanced Business Analytics System for SL-Core Framework'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/img/*.png',
    'html/img/*.jpg'
}

dependencies {
    'sl-core',
    'sl-business',
    'sl-banking',
    'sl-payroll',
    'oxmysql'
}

lua54 'yes'
