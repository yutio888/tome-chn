-- TE4 - T-Engine 4
-- Copyright (C) 2009, 2010, 2011, 2012 Nicolas Casalini
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
	default = { "sym:_SPACE:false:false:false:false" },
	type = "USERCHAT_TALK",
	group = "user chat",
	name = "聊天",
}

defineAction{
	default = { "sym:_SPACE:true:false:false:false" },
	type = "USERCHAT_SHOW_TALK",
	group = "user chat",
	name = "显示聊天记录",
}

defineAction{
	default = { "sym:_SPACE:false:true:false:false" },
	type = "USERCHAT_SWITCH_CHANNEL",
	group = "user chat",
	name = "循环聊天频道",
}
