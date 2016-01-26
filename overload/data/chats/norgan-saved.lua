-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2016 Nicolas Casalini
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
	text = [[谢谢你 @playername@ ，为了帝国的财富我们都活下来了。我会把这些消息带给他们。
我可不希望和死神再来一次亲密接触了。
再见。]],
	answers = {
		{"帝国万岁！多保重。", action=function(npc, player)
			npc:disappear()
			world:gainAchievement("NORGAN_SAVED", player)
		end},
	}
}

return "welcome"
