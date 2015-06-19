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
	default = { "sym:_l:true:false:false:false" },
	type = "LUA_CONSOLE",
	group = "debug",
	name = "显示lua命令行",
	only_on_cheat = true,
}

defineAction{
	default = { "sym:_a:true:false:false:false" },
	type = "DEBUG_MODE",
	group = "debug",
	name = "开关DEBUG模式",
	only_on_cheat = true,
}
