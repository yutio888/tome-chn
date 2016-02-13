-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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

newChat{ id="kyless",
	text = [[#VIOLET#*克里斯躺在地板上奄奄一息。他的手里还握着一本书。*#LAST#
求求你！在我死前我有一个请求！毁掉这本书。其实不是我，是这本书将灾难带给了我们。它必须被毁掉！]],
	answers = {
		{
			"好的。 #LIGHT_GREEN#[毁掉那本书]#LAST#",
			action=function(npc, player)
				player:hasQuest("keepsake"):on_good_choice(player)
			end,
			jump="destroy_book"
		},
		{
			"对不起我需要它。#LIGHT_GREEN#[拿走这本书]#LAST#",
			action=function(npc, player)
				player:hasQuest("keepsake"):on_evil_choice(player)
				player:hasQuest("keepsake"):on_keep_book(player)
			end,
			jump="keep_book"
		}
	}
}

newChat{ id="destroy_book",
	text = [[#VIOLET#*你毁掉了这本书。当你做完这一切后，你发现克里斯已经死了。*#LAST#]],
	answers = {
		{"再见，克里斯。"},
	}
}

newChat{ id="keep_book",
	text = [[#VIOLET#*你将这本书放到了背包里。当你做完这一切后，你发现克里斯已经死了。*#LAST#]],
	answers = {
		{"再见，克里斯。"},
	}
}

return "kyless"
