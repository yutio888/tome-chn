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
	text = [[#LIGHT_GREEN#*闪烁的光线照亮在草地上。经过调查,你发现一个孤单的太阳骑士躺在地上。她的伤口很小,但她苍白的神色显示出她身中剧毒。她无力的对你呼唤。* #白色#
救命,请帮我。
]],
	answers = {
		{"我该做些什么?", jump="next1"},
	}
}

newChat{ id="next1",
	text = [[我找到了...艾伦让我去寻找的那个令人憎恶的东西。兽人育种棚...比你能想象的还要邪恶一万倍...他们把它隐藏在远离他们的营地的地方,远离他们所有人的视线。他们的母亲、孩子，全在那里！
#LIGHT_GREEN#*她掏出一张地图，努力地递到你手中。*#WHITE#

这将是最后的解决方案，让战争终结...永远终结。我们必须马上行动，在那里的防御被增强之前...

#LIGHT_GREEN#*她努力地盯着你，用她所有的力气来祈求。*#WHITE#]],
	answers = {
		{"我一个人做不到...我会告诉艾伦，让她来决定。", action=function(npc, player)
			player:grantQuest("orc-breeding-pits")
			player:setQuestStatus("orc-breeding-pits", engine.Quest.COMPLETED, "wuss-out")
		end},
		{"我马上就去，一个人足以解决它们全部。", action=function(npc, player)
			player:grantQuest("orc-breeding-pits")
			local q = player:hasQuest("orc-breeding-pits")
			q:reveal()
		end},
		{"你让我去杀害母亲和孩子？！这过于残忍了，我绝不接受！"},
	}
}

return "welcome"
