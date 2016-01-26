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

local has_rod = function(npc, player)
	return player:findInAllInventoriesBy("define_as", "ROD_OF_RECALL") and not player:isQuestStatus("shertul-fortress", engine.Quest.COMPLETED, "butler")
end
local read = player:attr("speaks_shertul")

newChat{ id="welcome",
	text = [[*#LIGHT_GREEN#在水晶球里你似乎能看到整个马基·埃亚尔，可能它也是用来控制这座堡垒的。
]]..(not read and [[你没有明白上面铭文的意思。#WHITE#*
#{italic}#"Rokzan krilt copru."#{normal}#]] or [[#WHITE#*#{italic}#"插入魔杖。"#{normal}#]]),
	answers = {
		{"[测试水晶球]", jump="examine", cond=has_rod},
		{"[飞起堡垒] -- #LIGHT_RED#FOR TESTING ONLY#LAST#]", action=function(npc, player) player:hasQuest("shertul-fortress"):fly() end, cond=function() return config.settings.cheat end},
		{"[开始巫妖形态仪式]", cond=function(npc, player) local q = player:hasQuest("lichform") return q and q:check_lichform(player) end, action=function(npc, player) player:setQuestStatus("lichform", engine.Quest.COMPLETED) end},
		{"[离开]"},
	}
}

newChat{ id="examine",
	text = [[*#LIGHT_GREEN#整个设施似乎完全是水晶制造，里面显现出已知世界的精确地图，包括南部的禁秘大陆。
上面有一个形状类似召回之杖的小孔。#WHITE#*]],
	answers = {
		{"[插入魔杖]", jump="activate"},
		{"[离开]"},
	}
}
newChat{ id="activate",
	text = [[*#LIGHT_GREEN#当你用魔杖接近水晶球时，你感觉到它发生了感应和共鸣。
一个影子从房间的角落里出现了！你赶紧拿回了法杖，但是那个影子还在。
当你走近时它看上去像你以前战斗过的恐魔，只是稍稍感觉有些退化。
那个东西有着粗略的人形，但它没有脑袋，只有像触角一样的肢体。看上去似乎不像是敌人。#WHITE#*]],
	answers = {
		{"[离开]", action=function(npc, player)
			player:hasQuest("shertul-fortress"):spawn_butler()
		end,},
	}
}

return "welcome"
