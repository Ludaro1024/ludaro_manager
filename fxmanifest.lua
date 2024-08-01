fx_version("cerulean")
game("gta5")
lua54("yes")

author("Ludaro")
description("Ludaro Vue Boilerplate")
version("1.0.0")

client_scripts({
	"client/game/framework.lua",
	"client/**/*",
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"server/framework.lua",
	"server/**/*",
})

shared_scripts({
	"@ox_lib/init.lua",
	"shared/**/*",
	"config/**/*"
})

ui_page({
	"html/dist/index.html",
})

files({
	"html/dist/**",
})

