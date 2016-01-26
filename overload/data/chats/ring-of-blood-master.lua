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

local function attack(str)
	return function(npc, player) engine.Faction:setFactionReaction(player.faction, npc.faction, -100, true) npc:doEmote(str, 150) end
end

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*在你面前站着一个矮小的人形生物，长着一个不成比例的脑袋。*#WHITE#
看，来了个什么人， @playerdescriptor.race@, 我相信你一定走错地方了。]],
	answers = {
		{"有可能，这里发生了什么事？", jump="what"},
	}
}

newChat{ id="what",
	text = [[这里是鲜血之环！听着，你现在有两个选择。
既然你看上去不像那些奴隶一样的炮灰，我会给你一个机会来玩一个游戏。
要是你不想参加这个奴隶游戏，恐怕你得从我面前消失了。]],
	answers = {
		{"奴隶？你没搞错吧！[攻击]", action=attack("You think so? Die.")},
		{"游戏？我喜欢，是个什么样的游戏？", jump="game"},
	}
}

newChat{ id="game",
	text = [[你看，很简单。我会精神控制一些野生怪物或者奴隶，你则用对面的指令水晶球来控制一个奴隶。
然后我们对战10轮，如果你的奴隶还活着，那你会赢得了一个戒指，鲜血呼唤。]],
	answers = {
		{"要是我输了呢？", jump="lose"},
		{"鲜血和死亡，但自己却不用冒生命危险，太有趣了！", jump="price"},
	}
}

newChat{ id="lose",
	text = [[一般你自己会成为我的奴隶，不过你看上去应该是个不错的选手，你可以再次尝试。]],
	answers = {
		{"鲜血和死亡，但自己却不用冒生命危险，太有趣了！", jump="price"},
	}
}

newChat{ id="price",
	text = [[好极了，哦对了我差点忘了，每次使用水晶球你得支付150金币。
对于你们这种冒险家来说我想肯定不过是九牛之一毛而已。]],
	answers = {
		{"150金币？呃……好吧当然。", action=function(npc) npc.can_talk = nil end},
	}
}

return "welcome"
