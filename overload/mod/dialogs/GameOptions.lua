-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

require "engine.class"
local Dialog = require "engine.ui.Dialog"
local TreeList = require "engine.ui.TreeList"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"
local GetQuantity = require "engine.dialogs.GetQuantity"
local Tabs = require "engine.ui.Tabs"
local GraphicMode = require("mod.dialogs.GraphicMode")
local FontPackage = require "engine.FontPackage"

module(..., package.seeall, class.inherit(Dialog))

function _M:init()
	-- we can be called from the boot menu, so make sure to load initial settings in this case
	dofile("/mod/settings.lua")

	Dialog.init(self, "Game Options", game.w * 0.8, game.h * 0.8)

	self.vsep = Separator.new{dir="horizontal", size=self.ih - 10}
	self.c_desc = Textzone.new{width=math.floor((self.iw - self.vsep.w)/2), height=self.ih, text=""}

	local tabs = {
		{title="UI", kind="ui"},
		{title="Gameplay", kind="gameplay"},
		{title="Online", kind="online"},
		{title="Misc", kind="misc"}
	}
	self:triggerHook{"GameOptions:tabs", tab=function(title, fct)
		local id = #tabs+1
		tabs[id] = {title=title, kind="hooktab"..id}
		self['generateListHooktab'..id] = fct
	end}

	self.c_tabs = Tabs.new{width=self.iw - 5, tabs=tabs, on_change=function(kind) self:switchTo(kind) end}

	self:loadUI{
		{left=0, top=0, ui=self.c_tabs},
		{left=0, top=self.c_tabs.h, ui=self.c_list},
		{right=0, top=self.c_tabs.h, ui=self.c_desc},
		{hcenter=0, top=5+self.c_tabs.h, ui=self.vsep},
	}
	self:setFocus(self.c_list)
	self:setupUI()

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:select(item)
	if item and self.uis[3] then
		self.uis[3].ui = item.zone
	end
end

function _M:isTome()
	return game.__mod_info.short_name == "tome"
end

function _M:switchTo(kind)
	self['generateList'..kind:capitalize()](self)
	self:triggerHook{"GameOptions:generateList", list=self.list, kind=kind}

	self.c_list = TreeList.new{width=math.floor((self.iw - self.vsep.w)/2), height=self.ih - 10, scrollbar=true, columns={
		{width=60, display_prop="name"},
		{width=40, display_prop="status"},
	}, tree=self.list, fct=function(item) end, select=function(item, sel) self:select(item) end}
	if self.uis and self.uis[2] then
		self.c_list.mouse.delegate_offset_x = self.uis[2].ui.mouse.delegate_offset_x
		self.c_list.mouse.delegate_offset_y = self.uis[2].ui.mouse.delegate_offset_y
		self.uis[2].ui = self.c_list
	end
end

function _M:generateListUi()
	-- Makes up the list
	local list = {}
	local i = 0

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"选择显示游戏世界的图像模式。\n默认是“Modern”模式。\n当你切换模式后，最好重新创建角色，不然图像可能看起来很奇怪。"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#图像模式#WHITE##{normal}#", status=function(item)
		local ts = GraphicMode.tiles_packs[config.settings.tome.gfx.tiles]
		local size = config.settings.tome.gfx.size or "???x???"
		return (ts and ts.name or "???").." <"..size..">"
	end, fct=function(item)
		game:registerDialog(GraphicMode.new())
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"令生物和抛射物移动更加平滑。设置为0时移动看起来是瞬间完成的。\n数值越高，画面显示的移动速度越慢。\n注意：这并不会改变该游戏的回合制机制。\n在你的角色图像仍在移动的时候，你仍旧可以移动它。"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#平滑移动#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.smooth_move)
	end, fct=function(item)
		game:registerDialog(GetQuantity.new("设置动画速度(越低越快)", "从 0 到 60", config.settings.tome.smooth_move, 60, function(qty)
			game:saveSettings("tome.smooth_move", ("tome.smooth_move = %d\n"):format(qty))
			config.settings.tome.smooth_move = qty
			if self:isTome() then engine.Map.smooth_scroll = qty end
			self.c_list:drawItem(item)
		end))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启或关闭生物在移动和攻击时的“抖动”动作动画。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#生物移动攻击动作#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.twitch_move and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.twitch_move = not config.settings.tome.twitch_move
		game:saveSettings("tome.twitch_move", ("tome.twitch_move = %s\n"):format(tostring(config.settings.tome.twitch_move)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启平滑的战争迷雾。\n关闭它会让雾看起来像是方块，同时让速度得到轻微的提升。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#平滑战争迷雾#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.smooth_fov and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.smooth_fov = not config.settings.tome.smooth_fov
		game:saveSettings("tome.smooth_fov", ("tome.smooth_fov = %s\n"):format(tostring(config.settings.tome.smooth_fov)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"界面样式，默认为金属，设置为简单可以节省屏幕空间。\n改变设置后必须重启游戏才能看到效果。"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#界面样式#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.ui_theme2):capitalize()
	end, fct=function(item)
		local uis = {{name="金属", ui="metal"}, {name="石头", ui="stone"}, {name="简单", ui="simple"}}
		self:triggerHook{"GameOptions:UIs", uis=uis}
		Dialog:listPopup("界面样式", "选择样式", uis, 300, 200, function(sel)
			if not sel or not sel.ui then return end
			game:saveSettings("tome.ui_theme2", ("tome.ui_theme2 = %q\n"):format(sel.ui))
			config.settings.tome.ui_theme2 = sel.ui
			self.c_list:drawItem(item)
		end)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"界面效果。默认UI效果 'Minimalist'。\n#LIGHT_RED#重启游戏后生效。"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#HUD 样式#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.uiset_mode):capitalize()
	end, fct=function(item)
		local huds = {{name="Minimalist", ui="Minimalist"}, {name="Classic", ui="Classic"}}
		self:triggerHook{"GameOptions:HUDs", huds=huds}
		Dialog:listPopup("HUD style", "Select style", huds, 300, 200, function(sel)
			if not sel or not sel.ui then return end
			game:saveSettings("tome.uiset_mode", ("tome.uiset_mode = %q\n"):format(sel.ui))
			config.settings.tome.uiset_mode = sel.ui
			self.c_list:drawItem(item)
		end)
	end,}

	if self:isTome() and game.uiset:checkGameOption("log_lines") then	
		local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"战斗日志显示行数 (经典HUD)."}
		list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#日志行数#WHITE##{normal}#", status=function(item)
			return tostring(config.settings.tome.log_lines)
		end, fct=function(item)
			game:registerDialog(GetQuantity.new("日志行数", "从 5 到 50", config.settings.tome.log_lines, 50, function(qty)
				qty = util.bound(qty, 5, 50)
				game:saveSettings("tome.log_lines", ("tome.log_lines = %d\n"):format(qty))
				config.settings.tome.log_lines = qty
				if self:isTome() then
					game.uiset.logdisplay.resizeToLines()
				end
				self.c_list:drawItem(item)
			end, 0))
		end,}
	end
	
	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"为每一个格子画线，令位置显示更清晰可见。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#显示地图表格线#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.show_grid_lines and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.show_grid_lines = not config.settings.tome.show_grid_lines
		game:saveSettings("tome.show_grid_lines", ("tome.show_grid_lines = %s\n"):format(tostring(config.settings.tome.show_grid_lines)))
		self.c_list:drawItem(item)
		if self:isTome() then game:createMapGridLines() end
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"选择字体样式。默认为Fantasy。Basic 为简化的小字体。\n重启游戏后生效。\n汉化者注：Basic仅适用于英文版。"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#字体类型#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.fonts.type):capitalize()
	end, fct=function(item)
		Dialog:listPopup("字体样式", "选择字体", {{name="Fantasy", type="fantasy"}, {name="Basic", type="basic"}}, 300, 200, function(sel)
			if not sel or not sel.type then return end
			game:saveSettings("tome.fonts", ("tome.fonts = { type = %q, size = %q }\n"):format(sel.type, config.settings.tome.fonts.size))
			config.settings.tome.fonts.type = sel.type
			self.c_list:drawItem(item)
		end)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"选择空格是否显示。\n隐藏后英文间不会显示空格，但显示后中文间可能会有多余的空格。\n你必须重启游戏才能看到效果。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#空格显示#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.show_spaces and "显示" or "隐藏")
	end, fct=function(item)
		config.settings.tome.show_spaces = not config.settings.tome.show_spaces
		game:saveSettings("tome.show_spaces", ("tome.show_spaces = %s\n"):format(tostring(config.settings.tome.show_spaces)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"选择字体大小。\n你必须重启游戏才能看到效果。"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#字体大小#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.fonts.size):capitalize()
	end, fct=function(item)
		Dialog:listPopup("字体大小", "选择尺寸", {{name="正常", size="normal"},{name="小字体", size="small"},{name="大字体", size="big"},}, 300, 200, function(sel)
			if not sel or not sel.size then return end
			game:saveSettings("tome.fonts", ("tome.fonts = { type = %q, size = %q }\n"):format(config.settings.tome.fonts.type, sel.size))
			config.settings.tome.fonts.size = sel.size
			self.c_list:drawItem(item)
		end)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"战斗和聊天信息开始消失之前的停留时间。\n设置为0则不会消失。"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#信息消失时间#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.log_fade)
	end, fct=function(item)
		game:registerDialog(GetQuantity.new("消失时间(秒)", "从 0 到 20", config.settings.tome.log_fade, 20, function(qty)
			qty = util.bound(qty, 0, 20)
			game:saveSettings("tome.log_fade", ("tome.log_fade = %d\n"):format(qty))
			config.settings.tome.log_fade = qty
			if self:isTome() then
				game.uiset.logdisplay:enableFading(config.settings.tome.log_fade)
				profile.chat:enableFading(config.settings.tome.log_fade)
			end
			self.c_list:drawItem(item)
		end, 0))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"更改角色上方闪过提示的停留时间。\n1表示停留很短，100表示停留10倍时间。"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#提示停留时间#WHITE##{normal}#", status=function(item)
		return tostring((config.settings.tome.flyers_fade_time or 10) )
	end, fct=function(item)
		game:registerDialog(GetQuantity.new("相对时间", "From 1 to 100", (config.settings.tome.flyers_fade_time or 10), 100, function(qty)
			qty = util.bound(qty, 1, 100)
			config.settings.tome.flyers_fade_time = qty
			game:saveSettings("tome.flyers_fade_time", ("tome.flyers_fade_time = %d\n"):format(qty))
			self.c_list:drawItem(item)
		end, 1))
	end,}

	if self:isTome() then
		if game.uiset:checkGameOption("icons_temp_effects") then
			local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"采用图标而非文字来表示状态效果。#WHITE#"}
			list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#图标状态效果#WHITE##{normal}#", status=function(item)
				return tostring(config.settings.tome.effects_icons and "开启" or "关闭")
			end, fct=function(item)
				config.settings.tome.effects_icons = not config.settings.tome.effects_icons
				game:saveSettings("tome.effects_icons", ("tome.effects_icons = %s\n"):format(tostring(config.settings.tome.effects_icons)))
				if self:isTome() then game.player.changed = true end
				self.c_list:drawItem(item)
			end,}
		end

		if game.uiset:checkGameOption("icons_hotkeys") then
			local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"采用图标快捷栏代替文字快捷栏。#WHITE#"}
			list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#图标快捷栏#WHITE##{normal}#", status=function(item)
				return tostring(config.settings.tome.hotkey_icons and "开启" or "关闭")
			end, fct=function(item)
				config.settings.tome.hotkey_icons = not config.settings.tome.hotkey_icons
				game:saveSettings("tome.hotkey_icons", ("tome.hotkey_icons = %s\n"):format(tostring(config.settings.tome.hotkey_icons)))
				if self:isTome() then game.player.changed = true game:resizeIconsHotkeysToolbar() end
				self.c_list:drawItem(item)
			end,}
		end

		if game.uiset:checkGameOption("hotkeys_rows") then
			local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"调整快捷栏行数。#WHITE#"}
			list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#图标快捷栏行数#WHITE##{normal}#", status=function(item)
				return tostring(config.settings.tome.hotkey_icons_rows)
			end, fct=function(item)
				game:registerDialog(GetQuantity.new("快捷栏行数", "从1到4", config.settings.tome.hotkey_icons_rows, 4, function(qty)
					qty = util.bound(qty, 1, 4)
					game:saveSettings("tome.hotkey_icons_rows", ("tome.hotkey_icons_rows = %d\n"):format(qty))
					config.settings.tome.hotkey_icons_rows = qty
					if self:isTome() then game:resizeIconsHotkeysToolbar() end
					self.c_list:drawItem(item)
				end, 1))
			end,}
		end
	end

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"当你点击快捷栏或者使用快捷键时，将在快捷栏对应技能上有视觉反馈。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#可视化快捷键反馈#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.visual_hotkeys and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.visual_hotkeys = not config.settings.tome.visual_hotkeys
		game:saveSettings("tome.visual_hotkeys", ("tome.visual_hotkeys = %s\n"):format(tostring(config.settings.tome.visual_hotkeys)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"当玩家或者NPC使用技能时，将在其头顶显示#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#地图显示使用技能#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.talents_flyers and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.talents_flyers = not config.settings.tome.talents_flyers
		game:saveSettings("tome.talents_flyers", ("tome.talents_flyers = %s\n"):format(tostring(config.settings.tome.talents_flyers)))
		self.c_list:drawItem(item)
	end,}
	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"调整快捷栏图标大小。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#快捷栏图标大小#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.hotkey_icons_size)
	end, fct=function(item)
		game:registerDialog(GetQuantity.new("调整快捷栏图标大小", "从32到64", config.settings.tome.hotkey_icons_size, 64, function(qty)
			qty = util.bound(qty, 32, 64)
			game:saveSettings("tome.hotkey_icons_size", ("tome.hotkey_icons_size = %d\n"):format(qty))
			config.settings.tome.hotkey_icons_size = qty
			if self:isTome() then game:resizeIconsHotkeysToolbar() end
			self.c_list:drawItem(item)
		end, 32))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"关闭后相同手札只会弹出一次。\n开启后，手札只会在你第一次看见时弹出。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#手札始终弹出#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.lore_popup and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.lore_popup = not config.settings.tome.lore_popup
		game:saveSettings("tome.lore_popup", ("tome.lore_popup = %s\n"):format(tostring(config.settings.tome.lore_popup)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"如果关闭，能使用的物品不会自动添加至快捷栏。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#物品自动添加入快捷栏#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.auto_hotkey_object and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.auto_hotkey_object = not config.settings.tome.auto_hotkey_object
		game:saveSettings("tome.auto_hotkey_object", ("tome.auto_hotkey_object = %s\n"):format(tostring(config.settings.tome.auto_hotkey_object)))
		self.c_list:drawItem(item)
	end,}

	if self:isTome() then
	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString[[切换血条显示模式:
- 血条+小框架 
- 血条+大框架
- 只显示血条
- 不显示
译者注：切换后该选项显示的模式没有改变，但游戏中可以发现模式已经改变。再次打开这个选项也能发现已经改变。
#{italic}#在游戏中按Shift+T可以直接切换#{normal}##WHITE#]]}
		list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#血条显示#WHITE##{normal}#", status=function(item)
			local vs = "血条+小框架"
			if game.always_target == "old" then
				 vs = "血条+大框架"
			elseif game.always_target == "health" then
				 vs = "只显示血条"
			elseif game.always_target == nil then
				 vs = "不显示"
			elseif game.always_target == true then
				 vs = "血条+小框架"
			end
			return vs
		end, fct=function(item)
			Dialog:listPopup("血条显示", "选择模式", {
				{name="血条+小框架", mode=true},
				{name="血条+大框架", mode="old"},
				{name="只显示血条", mode="health"},
				{name="不显示", mode=nil},
			}, 300, 200, function(sel)
				if not sel then return end
				game:setTacticalMode(sel.mode)
				self.c_list:drawItem(item)
			end)
		end,}
	end

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"血条切换：正常或者旗杆#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#旗杆样式#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.flagpost_tactical and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.flagpost_tactical = not config.settings.tome.flagpost_tactical
		game:saveSettings("tome.flagpost_tactical", ("tome.flagpost_tactical = %s\n"):format(tostring(config.settings.tome.flagpost_tactical)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"血条切换：侧边或者底部#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#血条位置#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.small_frame_side and "侧边" or "底部")
	end, fct=function(item)
		config.settings.tome.small_frame_side = not config.settings.tome.small_frame_side
		game:saveSettings("tome.small_frame_side", ("tome.small_frame_side = %s\n"):format(tostring(config.settings.tome.small_frame_side)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"如果关闭，当眩晕或震慑时你不会得到全屏效果提示。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#全屏眩晕震慑效果#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.fullscreen_stun and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.fullscreen_stun = not config.settings.tome.fullscreen_stun
		game:saveSettings("tome.fullscreen_stun", ("tome.fullscreen_stun = %s\n"):format(tostring(config.settings.tome.fullscreen_stun)))
		self.c_list:drawItem(item)
		if self:isTome() then if game.player.updateMainShader then game.player:updateMainShader() end end
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"如果关闭，当混乱时你不会得到全屏效果提示。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#全屏混乱效果#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.fullscreen_confusion and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.fullscreen_confusion = not config.settings.tome.fullscreen_confusion
		game:saveSettings("tome.fullscreen_confusion", ("tome.fullscreen_confusion = %s\n"):format(tostring(config.settings.tome.fullscreen_confusion)))
		self.c_list:drawItem(item)
		if self:isTome() then if game.player.updateMainShader then game.player:updateMainShader() end end
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"高级武器数据显示#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#高级武器数据#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.advanced_weapon_stats and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.advanced_weapon_stats = not config.settings.tome.advanced_weapon_stats
		game:saveSettings("tome.advanced_weapon_stats", ("tome.advanced_weapon_stats = %s\n"):format(tostring(config.settings.tome.advanced_weapon_stats)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"当你用右键画出鼠标手势时，会显示彩色的轨迹提示。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#显示鼠标手势轨迹#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.hide_gestures and "关闭" or "开启")
	end, fct=function(item)
		config.settings.hide_gestures = not config.settings.hide_gestures
		game:saveSettings("hide_gestures", ("hide_gestures = %s\n"):format(tostring(config.settings.hide_gestures)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"如果开启，任何任务信息变化都将以更明显的方式显示在屏幕上。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#大号任务提示#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.quest_popup and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.quest_popup = not config.settings.tome.quest_popup
		game:saveSettings("tome.quest_popup", ("tome.quest_popup = %s\n"):format(tostring(config.settings.tome.quest_popup)))
		self.c_list:drawItem(item)
	end,}

	self.list = list
end

function _M:generateListGameplay()
	-- Makes up the list
	local list = {}
	local i = 0

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"定义屏幕边缘到人物的距离。设置得足够高的话，人物会保持正中央。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#Scroll distance#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.scroll_dist)
	end, fct=function(item)
		game:registerDialog(GetQuantity.new("距离", "从1到30", config.settings.tome.scroll_dist, 30, function(qty)
			qty = util.bound(qty, 1, 30)
			game:saveSettings("tome.scroll_dist", ("tome.scroll_dist = %d\n"):format(qty))
			config.settings.tome.scroll_dist = qty
			self.c_list:drawItem(item)
		end, 1))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启/关闭天气效果。\n关闭它可能提升性能。不影响已经去过的区域。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#天气效果#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.weather_effects and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.weather_effects = not config.settings.tome.weather_effects
		game:saveSettings("tome.weather_effects", ("tome.weather_effects = %s\n"):format(tostring(config.settings.tome.weather_effects)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启/关闭昼夜光照变化效果#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#昼夜光照#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.daynight and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.daynight = not config.settings.tome.daynight
		game:saveSettings("tome.daynight", ("tome.daynight = %s\n"):format(tostring(config.settings.tome.daynight)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启鼠标左键移动.#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#鼠标移动#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.mouse_move and "开启" or "关闭")
	end, fct=function(item)
		config.settings.mouse_move = not config.settings.mouse_move
		game:saveSettings("mouse_move", ("mouse_move = %s\n"):format(tostring(config.settings.mouse_move)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启快捷近战攻击。\n近战攻击时可以用方向键指定目标。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#快捷近战攻击#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.immediate_melee_keys and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.immediate_melee_keys = not config.settings.tome.immediate_melee_keys
		game:saveSettings("tome.immediate_melee_keys", ("tome.immediate_melee_keys = %s\n"):format(tostring(config.settings.tome.immediate_melee_keys)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启快捷近战自动攻击。\n近战攻击时若只有一个临近目标则自动攻击。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#快捷近战自动攻击#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.immediate_melee_keys_auto and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.immediate_melee_keys_auto = not config.settings.tome.immediate_melee_keys_auto
		game:saveSettings("tome.immediate_melee_keys_auto", ("tome.immediate_melee_keys_auto = %s\n"):format(tostring(config.settings.tome.immediate_melee_keys_auto)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启鼠标指定目标功能。如果关闭，技能指定目标时不受鼠标移动影响。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#鼠标指定目标#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.disable_mouse_targeting and "关闭" or "开启")
	end, fct=function(item)
		config.settings.tome.disable_mouse_targeting = not config.settings.tome.disable_mouse_targeting
		game:saveSettings("tome.disable_mouse_targeting", ("tome.disable_mouse_targeting = %s\n"):format(tostring(config.settings.tome.disable_mouse_targeting)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"自动选择目标。使用技能、装备等时不再要求指定目标。\n#LIGHT_RED#注意：这非常危险。#WHITE#\n\n默认目标会遵循以下规则选择：\n - 最后一个鼠标划过的目标。\n - 最后一个攻击的目标\n - 最近的目标"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#自动选择目标#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.auto_accept_target and "开启" or "关闭")
	end, fct=function(item)
		config.settings.auto_accept_target = not config.settings.auto_accept_target
		game:saveSettings("auto_accept_target", ("auto_accept_target = %s\n"):format(tostring(config.settings.auto_accept_target)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"新游戏开始时部分技能点自动分配。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#出生自动分配技能点#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.autoassign_talents_on_birth and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.autoassign_talents_on_birth = not config.settings.tome.autoassign_talents_on_birth
		game:saveSettings("tome.autoassign_talents_on_birth", ("tome.autoassign_talents_on_birth = %s\n"):format(tostring(config.settings.tome.autoassign_talents_on_birth)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"自动探索前休息至尽可能满状态#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#自动探索前休息#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.rest_before_explore and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.rest_before_explore = not config.settings.tome.rest_before_explore
		game:saveSettings("tome.rest_before_explore", ("tome.rest_before_explore = %s\n"):format(tostring(config.settings.tome.rest_before_explore)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"当切换一件带有附着物的装备时，自动将附着物切换至新装备上。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#附着物自动切换#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.tinker_auto_switch and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.tinker_auto_switch = not config.settings.tome.tinker_auto_switch
		game:saveSettings("tome.tinker_auto_switch", ("tome.tinker_auto_switch = %s\n"):format(tostring(config.settings.tome.tinker_auto_switch)))
		self.c_list:drawItem(item)
	end,}

	self.list = list
end

function _M:generateListOnline()
	-- Makes up the list
	local list = {}
	local i = 0

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"设置聊天信息过滤器，选择接受信息#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#聊天信息过滤器#WHITE##{normal}#", status=function(item)
		return "返回"
	end, fct=function(item)
		game:registerDialog(require("engine.dialogs.ChatFilter").new({
			{name="死亡", kind="death"},
			{name="物品和生物链接", kind="link"},
		}))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"设置聊天信息屏蔽器。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#聊天信息屏蔽列表：#WHITE##{normal}#", status=function(item)
		return "返回"
	end, fct=function(item)	game:registerDialog(require("engine.dialogs.ChatIgnores").new()) end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"设置聊天信息接受频道。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#聊天信息频道#WHITE##{normal}#", status=function(item)
		return "select to configure"
	end, fct=function(item)	game:registerDialog(require("engine.dialogs.ChatChannels").new()) end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"允许在线事件。\n关闭有可能错过某些有趣的事情。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#在线事件#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.allow_online_events and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.allow_online_events = not config.settings.tome.allow_online_events
		game:saveSettings("tome.allow_online_events", ("tome.allow_online_events = %s\n"):format(tostring(config.settings.tome.allow_online_events)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"在外部浏览器中开启链接。\n这不影响插件浏览和安装等固定在游戏内的功能。"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#外部浏览器打开超链接#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.open_links_external and "开启" or "关闭")
	end, fct=function(item)
		config.settings.open_links_external = not config.settings.open_links_external
		game:saveSettings("open_links_external", ("open_links_external = %s\n"):format(tostring(config.settings.open_links_external)))
		self.c_list:drawItem(item)
	end,}

	self.list = list
end

function _M:generateListMisc()
	-- Makes up the list
	local list = {}
	local i = 0

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"后台存档。不建议关闭。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#后台存档#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.background_saves and "开启" or "关闭")
	end, fct=function(item)
		config.settings.background_saves = not config.settings.background_saves
		game:saveSettings("background_saves", ("background_saves = %s\n"):format(tostring(config.settings.background_saves)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"在地图的每一层自动存档。\n会增加存档次数，同时节省存档时间。\n不影响已探索区域。\n注意：并不会在每一层完整存档！\n不建议关闭。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#每层地图自动存档#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.save_zone_levels and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.save_zone_levels = not config.settings.tome.save_zone_levels
		game:saveSettings("tome.save_zone_levels", ("tome.save_zone_levels = %s\n"):format(tostring(config.settings.tome.save_zone_levels)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"不允许可能令人不快的开始图片.#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#开始图片审查#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.censor_boot and "开启" or "关闭")
	end, fct=function(item)
		config.settings.censor_boot = not config.settings.censor_boot
		game:saveSettings("censor_boot", ("censor_boot = %s\n"):format(tostring(config.settings.censor_boot)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"当戴着斗篷时，用斗篷代替头部装备图像#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#显示斗篷#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.tome.show_cloak_hoods and "开启" or "关闭")
	end, fct=function(item)
		config.settings.tome.show_cloak_hoods = not config.settings.tome.show_cloak_hoods
		game:saveSettings("tome.show_cloak_hoods", ("tome.show_cloak_hoods = %s\n"):format(tostring(config.settings.tome.show_cloak_hoods)))
		self.c_list:drawItem(item)
		if self:isTome() and game.level then
			for uid, e in pairs(game.level.entities) do
				if e.updateModdableTile then e:updateModdableTile() end
			end
		end
	end,}

	self.list = list
end
