fx_version "bodacious"
game "gta5"
lua54 "yes"

author "flexiboi"
description "Flex-moneywash"
version "1.0.0"

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
}

server_scripts {
    'server/main.lua',
}

client_scripts {
	'client/main.lua',
}

dependencies {
	'qb-core'
}
