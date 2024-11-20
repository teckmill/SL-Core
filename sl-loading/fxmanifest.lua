fx_version 'cerulean'
game 'gta5'

description 'SL-Loading - Loading Screen System'
version '1.0.0'

loadscreen 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/img/*.svg',
    'html/fonts/*.ttf',
    'html/music/*.mp3',
    'html/music/*.ogg'
}

loadscreen_manual_shutdown 'yes'

client_script 'client/main.lua'
server_script 'server/main.lua'

shared_script 'config.lua'
