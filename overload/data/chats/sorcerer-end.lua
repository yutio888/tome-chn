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

local p = game.party:findMember{main=true}

local function void_portal_open(npc, player)
	-- Charred scar was successful
	if player:hasQuest("charred-scar") and player:hasQuest("charred-scar"):isCompleted("stopped") then return false end
	return true
end
local function aeryn_alive(npc, player)
	for uid, e in pairs(game.level.entities) do
		if e.define_as and e.define_as == "HIGH_SUN_PALADIN_AERYN" then return e end
	end
end


--------------------------------------------------------
-- Yeeks have a .. plan
--------------------------------------------------------
if p.descriptor.race == "Yeek" then
newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*两个魔法师死在你面前。*#WHITE#
#LIGHT_GREEN#*他们的尸体化成了一缕青烟，很快消失了。*#WHITE#
#LIGHT_GREEN#*你感觉到维网和你发生了联系，整个夺心魔族在和你对话。*#WHITE#
你完成了令人难以置信的使命，]]..(p.female and "姐妹" or "兄弟")..[[！你也为夺心魔族创造了千载难逢的机会！
远古传送门的能量强大到难以想象，我们可以利用这个能量扩展维网到整个埃亚尔，并进入其他种族，将我们从维网中得到的和平与幸福带给他们。
你必须穿过传送门，牺牲你自己，你的精神意志会使能量注入维网并使维网向远处传播。
虽然你会死去，但是你会给这个世界和夺心魔族带来永久的和平。
维网永远不会忘记你，现在，去创造历史吧！
]],
	answers = {
		{"#LIGHT_GREEN#[牺牲你自己，将维网传播到所有生命。]", action=function(npc, player)
			player.no_resurrect = true
			player:die(player, {special_death_msg="sacrificing "..string.his_her_self(player).." to bring the Way to all"})
			player:setQuestStatus("high-peak", engine.Quest.COMPLETED, "yeek")
			player:hasQuest("high-peak"):win("yeek-sacrifice")
		end},
		{"但是……我做了那么多，我或者一样可以为维网做那么多！", jump="yeek-unsure"},
	}
}

newChat{ id="yeek-unsure",
	text = [[#LIGHT_GREEN#*你感到维网充斥了你的身心*#WHITE#
你会按照所要求的去做，为了整个夺心魔族！维网总是正确的。
]],
	answers = {
		{"#LIGHT_GREEN#[牺牲你自己，将维网传播到所有生命。]", action=function(npc, player)
			player.no_resurrect = true
			player:die(player, {special_death_msg="sacrificing "..string.his_her_self(player).." to bring the Way to all"})
			player:setQuestStatus("high-peak", engine.Quest.COMPLETED, "yeek")
			player:hasQuest("high-peak"):win("yeek-sacrifice")
		end},
		{"#LIGHT_GREEN#[在最后关头你用意志抵抗了维网几秒钟，向艾伦传递了信息。]#WHITE# 艾伦女士，快杀了我！#{bold}#现在！#{normal}#",
			cond=function(npc, player) return not void_portal_open(nil, player) and aeryn_alive(npc, player) and player:getWil() >= 55 end, jump="yeek-stab"
		},
	}
}

newChat{ id="yeek-stab",
	text = [[#LIGHT_GREEN#*通过你的精神力量，艾伦明白了维网的计划。*#WHITE#
你是一位伟大的盟友和罕见的伙伴。我发誓，整个世界都会铭记你的牺牲。
#LIGHT_GREEN#*一边说，她一边用剑刺入你的身体，终结了维网的计划。*#WHITE#
]],
	answers = {
		{"#LIGHT_GREEN#[平静地走向死亡。]", action=function(npc, player)
			player.no_resurrect = true
			player:die(player, {special_death_msg="sacrificing "..string.his_her_self(player).." to stop the Way"})
			player:setQuestStatus("high-peak", engine.Quest.COMPLETED, "yeek-stab")
			player:hasQuest("high-peak"):win("yeek-selfless")
		end},
	}
}

return "welcome"
end

--------------------------------------------------------
-- Default
--------------------------------------------------------

---------- If the void portal has been opened
if void_portal_open(nil, p) then
newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*两个魔法师死在你面前。*#WHITE#
#LIGHT_GREEN#*他们的尸体化成了一缕青烟，很快消失了。*#WHITE#
但是虚空传送门仍然打开着，在造物主穿过之前必须得关闭，否则一切努力都白费了！
你搜索魔法师的尸体找到了一本笔记，上面写道：想要关闭传送门，只有牺牲一个生命才行。]],
	answers = {
		{"艾伦，很抱歉我们之中得有一个人牺牲才能维持这个世界的存在。#LIGHT_GREEN#[为了这个世界牺牲艾伦]", jump="aeryn-sacrifice", cond=aeryn_alive},
		{"我会关闭它。#LIGHT_GREEN#[为了这个世界牺牲你自己。]", action=function(npc, player)
			player.no_resurrect = true
			player:die(player, {special_death_msg="sacrificing "..string.his_her_self(player).." for the sake of the world"})
			player:hasQuest("high-peak"):win("self-sacrifice")
		end},
	}
}

newChat{ id="aeryn-sacrifice",
	text = [[真不敢相信我们成功了。我已经准备好去死了，至少我知道我的牺牲不会白费。
请你确保这个世界的和平。]],
	answers = {
		{"你会永远被人铭记。", action=function(npc, player)
			local aeryn = aeryn_alive(npc, player)
			game.level:removeEntity(aeryn, true)
			player:hasQuest("high-peak"):win("aeryn-sacrifice")
		end},
	}
}

----------- If the void portal is still closed
else
newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*两个魔法师死在你面前。*#WHITE#
#LIGHT_GREEN#*他们的尸体化成了一缕青烟消失了。*#WHITE#
你赢得了这个游戏！
马基·埃亚尔和远东大陆从法师会的黑暗计划和他们的神手中获救了。]],
	answers = {
		{"艾伦，你还好么？", jump="aeryn-ok", cond=aeryn_alive},
		{"[离开]", action=function(npc, player) player:hasQuest("high-peak"):win("full") end},
	}
}

newChat{ id="aeryn-ok",
	text = [[真不敢相信我们成功了！我准备好去死了但我还活着。
我可能低估你了，你做了比我们预想的多的多的事情。]],
	answers = {
		{"我们俩都是。", action=function(npc, player) player:hasQuest("high-peak"):win("full") end},
	}
}
end


return "welcome"
