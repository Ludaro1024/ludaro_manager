fx_version("cerulean")
game("gta5")
lua54("yes")
name("ludaro_manager")
author("Ludaro")
description("Ludaro Manager is a FiveM resource that allows you to manage your server with ease. It includes a lot of features that will help you manage your server.")
version("1.1")

client_scripts({
	"client/NativeUILua/Wrapper/Utility.lua",
	"client/NativeUILua/UIElements/UIVisual.lua",
	"client/NativeUILua/UIElements/UIResRectangle.lua",
	"client/NativeUILua/UIElements/UIResText.lua",
	"client/NativeUILua/UIElements/Sprite.lua",
	"client/NativeUILua/UIMenu/elements/Badge.lua",
	"client/NativeUILua/UIMenu/elements/Colours.lua",
	"client/NativeUILua/UIMenu/elements/ColoursPanel.lua",
	"client/NativeUILua/UIMenu/elements/StringMeasurer.lua",
	"client/NativeUILua/UIMenu/items/UIMenuItem.lua",
	"client/NativeUILua/UIMenu/items/UIMenuCheckboxItem.lua",
	"client/NativeUILua/UIMenu/items/UIMenuListItem.lua",
	"client/NativeUILua/UIMenu/items/UIMenuSliderItem.lua",
	"client/NativeUILua/UIMenu/items/UIMenuSliderHeritageItem.lua",
	"client/NativeUILua/UIMenu/items/UIMenuColouredItem.lua",
	"client/NativeUILua/UIMenu/items/UIMenuProgressItem.lua",
	"client/NativeUILua/UIMenu/items/UIMenuSliderProgressItem.lua",
	"client/NativeUILua/UIMenu/windows/UIMenuHeritageWindow.lua",
	"client/NativeUILua/UIMenu/panels/UIMenuGridPanel.lua",
	"client/NativeUILua/UIMenu/panels/UIMenuHorizontalOneLineGridPanel.lua",
	"client/NativeUILua/UIMenu/panels/UIMenuVerticalOneLineGridPanel.lua",
	"client/NativeUILua/UIMenu/panels/UIMenuColourPanel.lua",
	"client/NativeUILua/UIMenu/panels/UIMenuPercentagePanel.lua",
	"client/NativeUILua/UIMenu/panels/UIMenuStatisticsPanel.lua",
	"client/NativeUILua/UIMenu/UIMenu.lua",
	"client/NativeUILua/UIMenu/MenuPool.lua",
	"client/NativeUILua/UITimerBar/UITimerBarPool.lua",
	"client/NativeUILua/UITimerBar/items/UITimerBarItem.lua",
	"client/NativeUILua/UITimerBar/items/UITimerBarProgressItem.lua",
	"client/NativeUILua/UITimerBar/items/UITimerBarProgressWithIconItem.lua",
	"client/NativeUILua/UIProgressBar/UIProgressBarPool.lua",
	"client/NativeUILua/UIProgressBar/items/UIProgressBarItem.lua",
	"client/NativeUILua/NativeUI.lua",
	"client/**/*",
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
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
	'locales/**/*',
})

dependencies({
	"ox_lib",
	"oxmysql",
	"es_extended",
})