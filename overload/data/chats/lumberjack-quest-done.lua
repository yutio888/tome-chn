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
	text = [[#LIGHT_GREEN#*本恩倒在你的脚下。*#WHITE#
感谢你把我从诅咒之中解脱出来……“咳咳”
我并不想……像这样……。
#LIGHT_GREEN#*他最后咳嗽了一声，死了。他的脸上带着笑容，诅咒终于从他的身上消失了。*#WHITE#]],
	answers = {
		{"安息吧。", action=function(npc, player) player:setQuestStatus("lumberjack-cursed", engine.Quest.COMPLETED) end},
	}
}

return "welcome"
