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

newChat{ id="caravan",
	text = [[#VIOLET#*作为商队最后的牺牲者，你看到他的双眼中满是仇恨。*#LAST#
我们那天应该杀了你。你不应该得到怜悯！]],
	answers = {
		{
			"那就让我来告诉你什么是无情。 #LIGHT_GREEN#[杀了他]#LAST#",
			action=function(npc, player)
				player:hasQuest("keepsake"):on_evil_choice(player)
				player:hasQuest("keepsake"):on_caravan_destroyed_chat_over(player)
			end
		},
		{
			"对不起。 #LIGHT_GREEN#[帮助他]#LAST#",
			action=function(npc, player)
				player:hasQuest("keepsake"):on_good_choice(player)
			end,
			jump="apology"
		},
	}
}

newChat{ id="apology",
	text = [[#VIOLET#*你刚想扶起他时，发现他已经失去了最后一线生机。*#LAST#]],
	answers = {
		{
			"...",
			action=function(npc, player)
				player:hasQuest("keepsake"):on_caravan_destroyed_chat_over(player)
			end,
		},
	}
}

return "caravan"
