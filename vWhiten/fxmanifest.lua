fx_version "adamant"

game "gta5"

description "Blanchisseur by KraKss"

version "1.0"

server_scripts {
	"@es_extended/locale.lua",
	"sv.lua"
}


client_scripts {
	"src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
	"@es_extended/locale.lua",
	"cl.lua"
}

shared_scripts {
    "config.lua"
}

dependencies {
	"es_extended"
}
