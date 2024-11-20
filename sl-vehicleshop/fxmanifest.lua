fx_version 'cerulean'
game 'gta5'

description 'SL-VehicleShop - Vehicle Shop System for SL Framework'
version '1.0.0'

shared_scripts {
    '@sl-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/main.lua',
    'client/menu.lua',
    'client/showroom.lua',
    'client/testdrive.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

lua54 'yes'
