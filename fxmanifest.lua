fx_version 'cerulean'
game 'gta5'

author 'Glocko'
description 'Metro Fast Travel system'
version '1.0'
client_scripts {
    --'@NativeUI/NativeUI.lua', -- This resource uses NativeUI by Frazzle
    'NativeUI.lua',
    'client.lua',
    'train.lua'
}
server_scripts {
    'server.lua',
    '@es_extended/imports.lua'
}

shared_script 'Config.lua'
