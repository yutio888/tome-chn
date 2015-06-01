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

newChat{ id="berethh",
	text = [[#VIOLET#*在你的面前站着的是贝里斯。他面无表情，只是摆出了攻击的姿势。#LAST#
]],
	answers = {
		{"克里斯死了。", jump="response"}
	}
}

newChat{ id="response",
	text = [[我不知道你是否该死。不管怎样，我要杀了你。]],
	answers = {
		{
			"那么你就会像克里斯一样死掉。#LIGHT_GREEN#[攻击]#LAST#",
			action=function(npc, player)
				player:hasQuest("keepsake"):on_evil_choice(player)
			end
		},
		{
			"我需要你的帮助。我想要克服我的诅咒。",
			action=function(npc, player)
				player:hasQuest("keepsake"):on_good_choice(player)
			end,
			jump="attack"
		},
		{
			"我不想杀你。",
			jump="attack"
		}
	}
}

newChat{ id="attack",
	text = [[#VIOLET#*贝里斯无视了你的请求，他拉开了弓弦准备攻击。*#LAST#]],
	answers = {
		{"#LIGHT_GREEN#[攻击]"},
	}
}

return "berethh"
