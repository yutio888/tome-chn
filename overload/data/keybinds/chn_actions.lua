-- TE4 - T-Engine 4
-- Copyright (C) 2009 - 2015 Nicolas Casalini
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

defineAction{
	default = { "uni:<", "uni:>" },
	type = "CHANGE_LEVEL",
	group = "actions",
	name = "到下一层/上一层地图",
}

defineAction{
	default = { "sym:=p:false:false:false:false", "sym:=g:false:true:false:false" },
	type = "LEVELUP",
	group = "actions",
	name = "打开升级面板",
}
defineAction{
	default = { "sym:=m:false:false:false:false" },
	type = "USE_TALENTS",
	group = "actions",
	name = "使用技能",
}

defineAction{
	default = { "sym:=j:false:false:false:false", "sym:_q:true:false:false:false" },
	type = "SHOW_QUESTS",
	group = "actions",
	name = "显示任务",
}

defineAction{
	default = { "sym:=r:false:false:false:false", "sym:=r:false:true:false:false" },
	type = "REST",
	group = "actions",
	name = "休息",
}

defineAction{
	default = { "sym:_s:true:false:false:false" },
	type = "SAVE_GAME",
	group = "actions",
	name = "保存游戏",
}

defineAction{
	default = { "sym:_x:true:false:false:false" },
	type = "QUIT_GAME",
	group = "actions",
	name = "退出游戏",
}

defineAction{
	default = { "sym:_t:false:true:false:false" },
	type = "TACTICAL_DISPLAY",
	group = "actions",
	name = "战术显示 开/关",
}

defineAction{
	default = { "sym:=l:false:false:false:false" },
	type = "LOOK_AROUND",
	group = "actions",
	name = "查看四周",
}

defineAction{
	default = { "sym:_TAB:false:false:false:false" },
	type = "TOGGLE_MINIMAP",
	group = "actions",
	name = "开关小地图",
}

defineAction{
	default = { "sym:=t:true:false:false:false" },
	type = "SHOW_TIME",
	group = "actions",
	name = "显示游戏内时间",
}

defineAction{
	default = { "sym:=c:false:false:false:false", "sym:=c:false:true:false:false" },
	type = "SHOW_CHARACTER_SHEET",
	group = "actions",
	name = "显示角色面板",
}

defineAction{
	default = { "sym:_s:false:false:true:false" },
	type = "SWITCH_GFX",
	group = "actions",
	name = "切换贴图模式",
}

defineAction{
	default = { "sym:_RETURN:false:false:false:false", "sym:_KP_ENTER:false:false:false:false" },
	type = "ACCEPT",
	group = "actions",
	name = "确认操作",
}

defineAction{
	default = { "sym:_ESCAPE:false:false:false:false" },
	type = "EXIT",
	group = "actions",
	name = "退出菜单",
}
