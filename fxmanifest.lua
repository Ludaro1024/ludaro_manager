fx_version("cerulean")
game("gta5")
lua54("yes")

author("Ludaro")
description("Ludaro Vue Boilerplate")
version("1.0.0")

client_scripts({
	"NativeUILua/Wrapper/Utility.lua",
	"NativeUILua/UIElements/UIVisual.lua",
	"NativeUILua/UIElements/UIResRectangle.lua",
	"NativeUILua/UIElements/UIResText.lua",
	"NativeUILua/UIElements/Sprite.lua",
	"NativeUILua/UIMenu/elements/Badge.lua",
	"NativeUILua/UIMenu/elements/Colours.lua",
	"NativeUILua/UIMenu/elements/ColoursPanel.lua",
	"NativeUILua/UIMenu/elements/StringMeasurer.lua",
	"NativeUILua/UIMenu/items/UIMenuItem.lua",
	"NativeUILua/UIMenu/items/UIMenuCheckboxItem.lua",
	"NativeUILua/UIMenu/items/UIMenuListItem.lua",
	"NativeUILua/UIMenu/items/UIMenuSliderItem.lua",
	"NativeUILua/UIMenu/items/UIMenuSliderHeritageItem.lua",
	"NativeUILua/UIMenu/items/UIMenuColouredItem.lua",
	"NativeUILua/UIMenu/items/UIMenuProgressItem.lua",
	"NativeUILua/UIMenu/items/UIMenuSliderProgressItem.lua",
	"NativeUILua/UIMenu/windows/UIMenuHeritageWindow.lua",
	"NativeUILua/UIMenu/panels/UIMenuGridPanel.lua",
	"NativeUILua/UIMenu/panels/UIMenuHorizontalOneLineGridPanel.lua",
	"NativeUILua/UIMenu/panels/UIMenuVerticalOneLineGridPanel.lua",
	"NativeUILua/UIMenu/panels/UIMenuColourPanel.lua",
	"NativeUILua/UIMenu/panels/UIMenuPercentagePanel.lua",
	"NativeUILua/UIMenu/panels/UIMenuStatisticsPanel.lua",
	"NativeUILua/UIMenu/UIMenu.lua",
	"NativeUILua/UIMenu/MenuPool.lua",
	"NativeUILua/UITimerBar/UITimerBarPool.lua",
	"NativeUILua/UITimerBar/items/UITimerBarItem.lua",
	"NativeUILua/UITimerBar/items/UITimerBarProgressItem.lua",
	"NativeUILua/UITimerBar/items/UITimerBarProgressWithIconItem.lua",
	"NativeUILua/UIProgressBar/UIProgressBarPool.lua",
	"NativeUILua/UIProgressBar/items/UIProgressBarItem.lua",
	"NativeUILua/NativeUI.lua",
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

dependencies({
	"ox_lib",
	"oxmysql",
})