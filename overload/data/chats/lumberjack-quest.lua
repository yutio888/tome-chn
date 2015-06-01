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
	text = [[#LIGHT_GREEN#*在你面前站着一个满身是血和污泥的男人。他上气不接下气，失魂落魄。*#WHITE#
救命！求你救救我们！#{bold}#它#{normal}#正在屠杀所有村子里的人！求求你！
#LIGHT_GREEN#*他伸手指着附近的树林。*#WHITE#]],
	answers = {
		{"我去看看我能做什么。", action=function(npc, player) player:grantQuest("lumberjack-cursed") end},
		{"和我没关系，闪开！"},
	}
}

return "welcome"
