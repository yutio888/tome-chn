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

-- Character movements
defineAction{
	default = { "sym:_LEFT:false:false:false:false", "sym:_KP_4:false:false:false:false" },
	type = "MOVE_LEFT",
	group = "movement",
	name = "向左移动",
}
defineAction{
	default = { "sym:_RIGHT:false:false:false:false", "sym:_KP_6:false:false:false:false" },
	type = "MOVE_RIGHT",
	group = "movement",
	name = "向右移动",
}
defineAction{
	default = { "sym:_UP:false:false:false:false", "sym:_KP_8:false:false:false:false" },
	type = "MOVE_UP",
	group = "movement",
	name = "向上移动",
}
defineAction{
	default = { "sym:_DOWN:false:false:false:false", "sym:_KP_2:false:false:false:false" },
	type = "MOVE_DOWN",
	group = "movement",
	name = "向下移动",
}
defineAction{
	default = { "sym:_KP_7:false:false:false:false" },
	type = "MOVE_LEFT_UP",
	group = "movement",
	name = "向左上方移动",
}
defineAction{
	default = { "sym:_KP_9:false:false:false:false" },
	type = "MOVE_RIGHT_UP",
	group = "movement",
	name = "向右上方移动",
}
defineAction{
	default = { "sym:_KP_1:false:false:false:false" },
	type = "MOVE_LEFT_DOWN",
	group = "movement",
	name = "向左下方移动",
}
defineAction{
	default = { "sym:_KP_3:false:false:false:false" },
	type = "MOVE_RIGHT_DOWN",
	group = "movement",
	name = "向右下方移动",
}

defineAction{
	default = { "sym:_KP_5:false:false:false:false" },
	type = "MOVE_STAY",
	group = "movement",
	name = "原地待命1回合",
}

-- Running
defineAction{
	default = { "sym:=.:false:false:false:false" },
	type = "RUN",
	group = "movement",
	name = "快速移动模式",
}
defineAction{
	default = { "sym:_LEFT:false:true:false:false", "sym:_KP_4:false:true:false:false" },
	type = "RUN_LEFT",
	group = "movement",
	name = "向左快速移动",
}
defineAction{
	default = { "sym:_RIGHT:false:true:false:false", "sym:_KP_6:false:true:false:false" },
	type = "RUN_RIGHT",
	group = "movement",
	name = "向右快速移动",
}
defineAction{
	default = { "sym:_UP:false:true:false:false", "sym:_KP_8:false:true:false:false" },
	type = "RUN_UP",
	group = "movement",
	name = "向上快速移动",
}
defineAction{
	default = { "sym:_DOWN:false:true:false:false", "sym:_KP_2:false:true:false:false" },
	type = "RUN_DOWN",
	group = "movement",
	name = "向下快速移动",
}
defineAction{
	default = { "sym:_KP_7:false:true:false:false" },
	type = "RUN_LEFT_UP",
	group = "movement",
	name = "向左上方快速移动",
}
defineAction{
	default = { "sym:_KP_9:false:true:false:false" },
	type = "RUN_RIGHT_UP",
	group = "movement",
	name = "向右上方快速移动",
}
defineAction{
	default = { "sym:_KP_1:false:true:false:false" },
	type = "RUN_LEFT_DOWN",
	group = "movement",
	name = "向左下方快速移动",
}
defineAction{
	default = { "sym:_KP_3:false:true:false:false" },
	type = "RUN_RIGHT_DOWN",
	group = "movement",
	name = "向右下方快速移动",
}
defineAction{
	default = { "sym:_z:false:false:false:false" },
	type = "RUN_AUTO",
	group = "movement",
	name = "自动探索",
}
