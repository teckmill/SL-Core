fx_version 'cerulean'
game 'gta5'

description 'SL Admin - Advanced Administration System'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    '@sl-core/client/wrapper.lua',
    '@sl-core/shared/utils.lua',
    'client/main.lua',
    'client/devtools.lua',
    'client/commands.lua',
    'client/noclip.lua',
    'client/spectate.lua',
    'client/reports.lua',
    'client/menu.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@sl-core/server/wrapper.lua',
    '@sl-core/shared/utils.lua',
    'server/main.lua',
    'server/commands.lua',
    'server/version.lua',
    'server/players.lua',
    'server/reports.lua',
    'server/logs.lua'
}

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/fonts/*.ttf'
}

dependencies {
    'sl-core',
    'sl-menu',
    'sl-input',
    'oxmysql'
}

lua54 'yes'
