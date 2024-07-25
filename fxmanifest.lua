fx_version("cerulean")
game("gta5")
lua54("yes")

author("Ludaro")
description("Ludaro Vue Boilerplate")
version("1.0.0")

client_scripts({
	"client/*.lua",
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"server/*.lua",
})

shared_scripts({
	"@ox_lib/init.lua",
	"config/*.lua"
})

ui_page({
	"html/dist/index.html",
})

files({
	"html/dist/**",
})

