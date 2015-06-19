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
	default = { "sym:=i:false:false:false:false", },
	type = "SHOW_INVENTORY",
	group = "inventory",
	name = "打开物品栏",
}
defineAction{
	default = { "sym:=e:false:false:false:false", },
	type = "SHOW_EQUIPMENT",
	group = "inventory",
	name = "打开装备栏",
}

defineAction{
	default = { "sym:=g:false:false:false:false" },
	type = "PICKUP_FLOOR",
	group = "inventory",
	name = "拾取物品",
}
defineAction{
	default = { "sym:=d:false:false:false:false" },
	type = "DROP_FLOOR",
	group = "inventory",
	name = "丢下物品",
}

defineAction{
	default = { "sym:=w:false:false:false:false", },
	type = "WEAR_ITEM",
	group = "inventory",
	name = "装备物品",
}
defineAction{
	default = { "sym:=t:false:false:false:false", },
	type = "TAKEOFF_ITEM",
	group = "inventory",
	name = "取下物品",
}

defineAction{
	default = { "sym:=u:false:false:false:false", },
	type = "USE_ITEM",
	group = "inventory",
	name = "使用",
}

defineAction{
	default = { "sym:=q:false:false:false:false", },
	type = "QUICK_SWITCH_WEAPON",
	group = "inventory",
	name = "快速切换武器",
}
