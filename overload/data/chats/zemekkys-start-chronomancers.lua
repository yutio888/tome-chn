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
	text = [[@playername@你为吾效力的时候到了。
	附近那些不忠诚的异端们正在蠢蠢欲动。
	你最好尽快过去，找到这一切的源头。]],
	answers = {
		{"我会的，伟大的守护者。", action=function() game:changeLevel(1, "unhallowed-morass") end},
		{"抱歉，我不能这么做。", action=function(npc, player) player:setQuestStatus("start-point-zero", engine.Quest.FAILED) end},
	}
}

return "welcome"
