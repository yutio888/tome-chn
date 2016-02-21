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
	template = [[#LIGHT_GREEN#*当你进入这个房间时，你发现两个身形魁梧的食人魔站在你的面前，仿佛刚刚从无尽的长眠中醒来。他们在看到你的瞬间迅速立正，右边的一个向你大喊到:*#WHITE#
你是谁！立刻报上你的姓名、军衔、部队番号！
]],
	answers = {
		{"我的什么？"},
		{"[攻击]"},
	}
}

newChat{ id="nargol-scum",
	template = [[#LIGHT_GREEN#*当你进入这个房间时，你发现两个身形魁梧的食人魔站在你的面前，仿佛刚刚从无尽的长眠中醒来。他们在看到你的瞬间立刻举起武器向你冲来。]],
	answers = {
		{"[攻击]", action=function(npc, player) npc:doEmote("#CRIMSON#纳格尔帝国的半身人杂种攻进来了！我们正遭受攻击！", 120) end},
	}
}

newChat{ id="conclave",
	template = [[#LIGHT_GREEN#*当你进入这个房间时，你发现两个身形魁梧的食人魔站在你的面前，仿佛刚刚从无尽的长眠中醒来。他们在看到你的瞬间迅速立正，右边的一个向你大喊道:*#WHITE#
太好了！我们的援军终于到了！我不知道已经过了多久，不过我想亚斯特莉可以告诉你们——等等，其他人呢？  #LIGHT_GREEN#*他的眉头紧锁。*#WHITE# 你的部队番号是什么！
]],
	answers = {
		{"等等！战争已经结束了！已经过去了几千年了，孔克雷夫也早已灭亡了！", jump="angry-conclave"},
		{"[攻击]"},
	}
}

newChat{ id="angry-conclave",
	text = [[#LIGHT_GREEN#*他们怒目而视，举起武器。左边的一个大喊道：*#WHITE#
一派胡言！孔克雷夫是不可能灭亡的！我不知道你到底是谁，但是你别想骗得了我们！
]],
	answers = {
		{"[攻击]"},
	}
}

if player.descriptor and player.descriptor.race == "Halfling" then
	return "nargol-scum"
elseif (player:findInAllInventoriesBy('define_as', 'CONCLAVE_ROBE') and player:findInAllInventoriesBy('define_as', 'CONCLAVE_ROBE').wielded and (player.descriptor.race == "Human" or player.descriptor.subrace == "Ogre")) then
	return "conclave"
else
	return "welcome"
end
