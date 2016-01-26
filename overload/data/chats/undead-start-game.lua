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
	text = [[#LIGHT_GREEN#*在你面前站着一个穿着黑色长袍的人类，他好像没有注意到你。*#WHITE#
#LIGHT_GREEN#*你站在一个召唤法阵里，没法移动。*#WHITE#
啊，对！好！又一件我的收藏品，没错，的确是很强力的一个！]],
	answers = {
		{"[听他说话]", jump="welcome2"},
	}
}

newChat{ id="welcome2",
	text = [[一个对抗敌人的强力工具，对，没错，他们都仇恨我，我要让他们尝尝我的厉害！
给他们点颜色看看！等着瞧！]],
	answers = {
		{"我不是你的工具！放开我！", jump="welcome3"},
	}
}

newChat{ id="welcome3",
	text = [[你不可能说话，你不可能说话的啊！你是一个奴隶，一件工具！
你是我的，安静点！
#LIGHT_GREEN#*当他的注意力开始分散时，你注意到召唤法阵正在消失，你可以活动了！*#WHITE#
]],
	answers = {
		{"[攻击]", action=function(npc, player)
			local floor = game.zone:makeEntityByName(game.level, "terrain", "SUMMON_CIRCLE_BROKEN")
			game.zone:addEntity(game.level, floor, "terrain", 22, 3)
		end},
	}
}

return "welcome"
