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

newChat{ id="welcome",

	text = [[#LIGHT_GREEN#*你们两个在沙滩上放松一了阵子。
空气清新无比，阳光照射在砂砾上，闪耀五颜六色的光芒，
耳边传来海浪轻柔地呼啸。*#WHITE#

出来旅行真好！
今天和你玩得很开心啊。

#LIGHT_GREEN#*她直视着你，眼睛里闪耀莫名的光芒。*#WHITE#]],
	answers = {
		{"#LIGHT_GREEN#[你靠了过去，亲吻了她]#WHITE#", action=function() game.zone.start_yaech() end, jump="firstbase"},
	}
}

newChat{ id="firstbase",
	text = [[在你们俩嘴唇相碰之前，你注意到有什么不对劲……
]],
	answers = {
		{"#LIGHT_GREEN#[继续...]#WHITE#"},
	}
}

return "welcome"
