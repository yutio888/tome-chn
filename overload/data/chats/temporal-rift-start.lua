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
	text = [[#LIGHT_GREEN#*一个高大的男人，全身像星星一样闪耀着光芒，在你面前出现了。*#WHITE#
噢，不，又来了一个“冒险家”！你不能把超出你理解范围的东西混为一谈！
不要搅进有关时间的事物里，时间流逝非常快，而且很容易被搅乱！
#LIGHT_GREEN#*他靠近并注视着你*#WHITE#
你看上去很强，帮帮我，在我修理时间线的时候帮我干掉那些憎恶，只有这样你才能离开这里！]],
	answers = {
		{"但是到底是怎么回事……", action = function(npc, player) game:changeLevel(2) game.player:grantQuest("temporal-rift") end},
	}
}

return "welcome"
