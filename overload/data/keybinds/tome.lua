-- ToME - Tales of Maj'Eyal
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
	default = { "sym:=c:false:false:false:false"},
	type = "SHOW_CHARACTER_SHEET",
	group = "actions",
	name = "显示角色面板(玩家)",
}

defineAction{
	default = { "sym:=c:false:true:false:false" },
	type = "SHOW_CHARACTER_SHEET_CURSOR",
	group = "actions",
	name = "显示角色面板 (角色 @ cursor)",
}

defineAction{
	default = { "sym:_TAB:true:false:false:false" },
	type = "SWITCH_PARTY",
	group = "party",
	name = "角色控制选择",
}

defineAction{
	default = { "sym:_F1:false:false:false:false" },
	type = "SWITCH_PARTY_1",
	group = "party",
	name = "切换至控制角色1",
}

defineAction{
	default = { "sym:_F2:false:false:false:false" },
	type = "SWITCH_PARTY_2",
	group = "party",
	name = "切换至控制角色2",
}

defineAction{
	default = { "sym:_F3:false:false:false:false" },
	type = "SWITCH_PARTY_3",
	group = "party",
	name = "切换至控制角色3",
}

defineAction{
	default = { "sym:_F4:false:false:false:false" },
	type = "SWITCH_PARTY_4",
	group = "party",
	name = "切换至控制角色4",
}

defineAction{
	default = { "sym:_F5:false:false:false:false" },
	type = "SWITCH_PARTY_5",
	group = "party",
	name = "切换至控制角色5",
}

defineAction{
	default = { "sym:_F6:false:false:false:false" },
	type = "SWITCH_PARTY_6",
	group = "party",
	name = "切换至控制角色6",
}

defineAction{
	default = { "sym:_F7:false:false:false:false" },
	type = "SWITCH_PARTY_7",
	group = "party",
	name = "切换至控制角色7",
}

defineAction{
	default = { "sym:_F8:false:false:false:false" },
	type = "SWITCH_PARTY_8",
	group = "party",
	name = "切换至控制角色8",
}

defineAction{
	default = { "sym:_F1:true:false:false:false" },
	type = "ORDER_PARTY_1",
	group = "party",
	name = "发布指令：角色1",
}

defineAction{
	default = { "sym:_F2:true:false:false:false" },
	type = "ORDER_PARTY_2",
	group = "party",
	name = "发布指令：角色2",
}

defineAction{
	default = { "sym:_F3:true:false:false:false" },
	type = "ORDER_PARTY_3",
	group = "party",
	name = "发布指令：角色3",
}

defineAction{
	default = { "sym:_F4:true:false:false:false" },
	type = "ORDER_PARTY_4",
	group = "party",
	name = "发布指令：角色4",
}

defineAction{
	default = { "sym:_F5:true:false:false:false" },
	type = "ORDER_PARTY_5",
	group = "party",
	name = "发布指令：角色5",
}

defineAction{
	default = { "sym:_F6:true:false:false:false" },
	type = "ORDER_PARTY_6",
	group = "party",
	name = "发布指令：角色6",
}

defineAction{
	default = { "sym:_F7:true:false:false:false" },
	type = "ORDER_PARTY_7",
	group = "party",
	name = "发布指令：角色7",
}

defineAction{
	default = { "sym:_F8:true:false:false:false" },
	type = "ORDER_PARTY_8",
	group = "party",
	name = "发布指令：角色8",
}

defineAction{
	default = { "sym:_b:false:true:false:false" },
	type = "TOGGLE_BUMP_ATTACK",
	group = "movement",
	name = "切换移动模式",
}

defineAction{
	default = { "sym:_LEFT:true:false:false:false", "sym:_KP_4:true:false:false:false" },
	type = "ATTACK_OR_MOVE_LEFT",
	group = "movement",
	name = "攻击左侧目标",
}

defineAction{
	default = { "sym:_RIGHT:true:false:false:false", "sym:_KP_6:true:false:false:false" },
	type = "ATTACK_OR_MOVE_RIGHT",
	group = "movement",
	name = "攻击右侧目标",
}

defineAction{
	default = { "sym:_UP:true:false:false:false", "sym:_KP_8:true:false:false:false" },
	type = "ATTACK_OR_MOVE_UP",
	group = "movement",
	name = "攻击上方目标",
}

defineAction{
	default = { "sym:_DOWN:true:false:false:false", "sym:_KP_2:true:false:false:false" },
	type = "ATTACK_OR_MOVE_DOWN",
	group = "movement",
	name = "攻击下方目标",
}

defineAction{
	default = { "sym:_KP_7:true:false:false:false" },
	type = "ATTACK_OR_MOVE_LEFT_UP",
	group = "movement",
	name = "攻击左上方目标",
}

defineAction{
	default = { "sym:_KP_9:true:false:false:false" },
	type = "ATTACK_OR_MOVE_RIGHT_UP",
	group = "movement",
	name = "攻击右上方目标",
}

defineAction{
	default = { "sym:_KP_1:true:false:false:false" },
	type = "ATTACK_OR_MOVE_LEFT_DOWN",
	group = "movement",
	name = "攻击左下方目标",
}

defineAction{
	default = { "sym:_KP_3:true:false:false:false" },
	type = "ATTACK_OR_MOVE_RIGHT_DOWN",
	group = "movement",
	name = "攻击右下方目标",
}

defineAction{
	default = { "sym:_w:false:false:true:false" },
	type = "TOGGLE_UI",
	group = "interface",
	name = "切换UI显示",
}

defineAction{
	default = { "sym:_l:false:true:false:false" },
	type = "LOCK_TOOLTIP",
	group = "interface",
	name = "锁定鼠标提示。",
}

defineAction{
	default = { "sym:_l:true:true:false:false" },
	type = "LOCK_TOOLTIP_COMPARE",
	group = "interface",
	name = "比较物品时锁定鼠标提示。",
}

defineAction{
	default = { "sym:_p:true:false:false:false" },
	type = "TOGGLE_AUTOTALENT",
	group = "action",
	name = "切换自动技能使用",
}
