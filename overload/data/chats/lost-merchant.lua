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
	text = [[救救我！我会好好报答你的……
*#LIGHT_GREEN#强盗头子猛抽了一下他的脸。#WHITE#*闭嘴！]],
	answers = {
		{"抱歉，我得走了。", action = function(npc, player) npc.can_talk = nil end},
	}
}

newChat{ id="welcome2",
	text = [[请带我离开这儿！]],
	answers = {
		{"跟我来，这里有条路可以出去。", action = function(npc, player) npc.can_talk = nil npc.cant_be_moved = nil end},
	}
}

if game.player:hasQuest("lost-merchant") and game.player:hasQuest("lost-merchant"):is_assassin_alive() then
	return "welcome"
else
	return "welcome2"
end
