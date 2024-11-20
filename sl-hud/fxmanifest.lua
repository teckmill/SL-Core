fx_version 'cerulean'
game 'gta5'

description 'SL-HUD - Advanced HUD System'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/health.lua',
    'client/armor.lua',
    'client/stamina.lua',
    'client/hunger.lua',
    'client/thirst.lua',
    'client/stress.lua',
    'client/voice.lua',
    'client/vehicle.lua',
    'client/minimap.lua',
    'client/streetname.lua',
    'client/compass.lua',
    'client/money.lua',
    'client/job.lua',
    'client/gang.lua',
    'client/weapons.lua'
}

server_scripts {
    'server/main.lua',
    'server/version.lua'
}

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/fonts/*.ttf',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/img/*.svg'
}
