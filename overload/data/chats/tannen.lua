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

local function check_materials_gave_orb(npc, player)
	local q = player:hasQuest("east-portal")
	if not q or not q:isCompleted("gotoreknor") or not q:isCompleted("gave-orb") then return false end

	local gem_o, gem_item, gem_inven_id = player:findInAllInventories("Resonating Diamond")
	local athame_o, athame_item, athame_inven_id = player:findInAllInventories("Blood-Runed Athame")
	return gem_o and athame_o
end

local function check_materials_withheld_orb(npc, player)
	local q = player:hasQuest("east-portal")
	if not q or not q:isCompleted("gotoreknor") or not q:isCompleted("withheld-orb") then return false end

	local gem_o, gem_item, gem_inven_id = player:findInAllInventories("Resonating Diamond")
	local athame_o, athame_item, athame_inven_id = player:findInAllInventories("Blood-Runed Athame")
	return gem_o and athame_o
end

if game.player:hasQuest("east-portal") and game.player:isQuestStatus("east-portal", engine.Quest.DONE) then
newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*没人回答.*#WHITE#]],
	answers = {
		{"[离开]"},
	}
}
elseif game.player:hasQuest("east-portal") and game.player:hasQuest("east-portal").wait_turn and game.player:hasQuest("east-portal").wait_turn > game.turn then
newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*没人回答，泰恩估计还在忙着研究水晶球。*#WHITE#]],
	answers = {
		{"[离开]"},
	}
}
else
newChat{ id="welcome",
	text = [[我能为你提供什么服务？我亲爱的 @playerdescriptor.race@?]],
	answers = {
		{"[告诉他关于法杖、多元水晶球和传送门的事。]", jump="east_portal1", cond=function(npc, player) local q = player:hasQuest("east-portal"); return q and q:isCompleted("talked-elder") and not q:isCompleted("gotoreknor") end},
		{"我有宝石和祭祀匕首。[交给他祭祀匕首和宝石]", jump="has_material_gave_orb", cond=check_materials_gave_orb},
		{"我有宝石和祭祀匕首。[交给他祭祀匕首和宝石]", jump="has_material_withheld_orb", cond=check_materials_withheld_orb},
		{"窃贼，卑鄙的凶手，准备去死吧！", jump="fake_orb_end", cond=function(npc, player) local q = player:hasQuest("east-portal"); return q and q:isCompleted("tricked-demon") end},
		{"你研究的怎么样了？我们可以创造传送门了么？", jump="wait_end", cond=function(npc, player) local q = player:hasQuest("east-portal"); return q and q:isCompleted("open-telmur") end},
		{"没事，抱歉，再见！"},
	}
}
end

---------------------------------------------------------------
-- Explain the situation and get quest going
---------------------------------------------------------------
newChat{ id="east_portal1",
	text = [[真令人惊讶！我在古代的文献和传说中读到过关于这个水晶球的资料。能让我看看么？]],
	answers = {
		{"[给他看多元水晶球]", jump="east_portal2"},
	}
}

newChat{ id="east_portal2",
	text = [[确实，这是一位杰出伟人的杰作。也许莱娜尼尔她自己也曾经参与过建造。你说你看不懂它的使用说明么？]],
	answers = {
		{"是的。[给他看伊莫克斯潦草的笔记]", jump="east_portal3"},
	}
}

newChat{ id="east_portal3",
	text = [[#LIGHT_GREEN#*他花了点时间阅读笔记*#WHITE# 啊！我知道了。我一开始没有看明白伊莫克斯的方法。现在我终于搞清楚了，是通过声音来启用的，他的字真得好好练一下。我们可以在这里重复他的方法，不过，照他所说的话，我们还需要血符文祭祀匕首和共鸣宝石。]],
	answers = {
		{"你知道去哪里寻找这两样东西么？", jump="east_portal4"},
	}
}

newChat{ id="east_portal4",
	text = [[假如兽人在瑞库纳深处制造了这样一个传送门的话，他们肯定有这两样东西。如果这些物品无法穿越他们所制造的传送门的话，那么就有理由相信这两样物品可能还在马基·埃亚尔。必须得搜寻瑞库纳，从传送门附近开始。或许在建造完传送门之后，祭祀匕首和宝石仍然留在离这里不远的地方。]],
	answers = {
		{"我会去寻找的，谢谢你。", jump="east_portal5"},
	}
}

newChat{ id="east_portal5",
	text = [[最后一件事，在你搜寻的时候我得研究一下多元水晶球。我缺少时空法师伊莫克斯所拥有的专业知识，如果我要重复他的工作我必须得花些时间研究这些内容。]],
	answers = {
		{"[交给他水晶球] ", action=function(npc, player) player:hasQuest("east-portal"):give_orb(player) end, jump="gave_orb"},
		{"我现在还需要水晶球", action=function(npc, player) player:hasQuest("east-portal"):withheld_orb(player) end, jump="withheld_orb"},
	}
}

newChat{ id="gave_orb",
	text = [[谢谢，我会小心谨慎使用的。]],
	answers = {
		{"再见，我会把祭祀匕首和宝石带回来的。", action=function(npc, player) player:hasQuest("east-portal"):setStatus(engine.Quest.COMPLETED, "gotoreknor") end},
	}
}

newChat{ id="withheld_orb",
	text = [[好极了，不用着急。要创造你需要的传送门我还得花上几天来学习一下呢。]],
	answers = {
		{"我明白了，我会把祭祀匕首和宝石带回来的。", action=function(npc, player) player:hasQuest("east-portal"):setStatus(engine.Quest.COMPLETED, "gotoreknor") end},
	}
}

---------------------------------------------------------------
-- back with materials
---------------------------------------------------------------
newChat{ id="has_material_gave_orb",
	text = [[很好，几天后你回来，我肯定把一切都准备好了。哦，带上这个。#LIGHT_GREEN#*他交给你一把钥匙。*#WHITE#他可以打开泰尔玛废墟,许多年以前肖塔人被封印在那里。要是你在废墟之中找到一份标题是《关于力场翻转与回复的可能性研究》的文献请帮我带回来，这样可以使传送门保留机会大大提高。]],
	answers = {
		{"谢谢你，再见。", action=function(npc, player) player:hasQuest("east-portal"):open_telmur(player) end},
	}
}

newChat{ id="has_material_withheld_orb",
	text = [[太好了，那你同意把水晶球留给我研究一段时间了？]],
	answers = {
		{"我可不希望它离开我的视线，抱歉。", jump="no_orb_loan"},
		{"给你，小心保护好。我必须得返回远东大陆了。", jump="orb_loan"},
	}
}

newChat{ id="no_orb_loan",
	text = [[#LIGHT_GREEN#*那个老人叹了口气。*#WHITE# 好吧，那我只好在你的监督下来做一些粗略的试验了。]],
	answers = {
		{"[交给他水晶球]", jump="no_orb_loan2"},
	}
}

newChat{ id="no_orb_loan2",
	text = [[谢谢，给我一点时间。#LIGHT_GREEN#*他开始心不在焉地前后踱着步，盯着水晶球。*#WHITE#]],
	answers = {
		{"[等待]", jump="no_orb_loan3"},
	}
}

newChat{ id="no_orb_loan3",
	text = [[#LIGHT_GREEN#*他停下踱步，回到水晶球前来。*#WHITE# 我想我知道大多数我需要的东西，不过一些细节内容还得搞搞清楚。必须回去找到那个精灵时空法师，问问他到底是使用回复力场还是反转力场，我可不敢瞎猜，要不然结果很可能令你不太高兴。]],
	answers = {
		{"我会回去寻找答案的。", action=function(npc, player) player:hasQuest("east-portal"):ask_east(player) end},
	}
}

newChat{ id="orb_loan",
	text = [[别害怕，几天后你回来，我肯定把一切都准备好了。哦，带上这个。 #LIGHT_GREEN#*他交给你一把钥匙。*#WHITE#他可以打开泰尔玛废墟,许多年以前肖塔人被封印在那里。要是你在废墟之中找到一份标题是《关于力场翻转与回复的可能性研究》的文献请帮我带回来，这样可以使传送门保留机会大大提高。]],
	answers = {
		{"谢谢，再见！", action=function(npc, player) player:hasQuest("east-portal"):open_telmur(player) end},
	}
}

---------------------------------------------------------------
-- Back to the treacherous bastard
---------------------------------------------------------------
newChat{ id="fake_orb_end",
	text = [[我可不这么想，笨蛋，低头看看。
#LIGHT_GREEN#*你注意到你正站在一个铭文传送门上。*#WHITE#]],
	answers = {
		{"等一下……", action=function(npc, player) player:hasQuest("east-portal"):tannen_tower(player) end},
	}
}

newChat{ id="wait_end",
	text = [[我准备好了，你还没好，低头看看。
#LIGHT_GREEN#*你注意到你正站在一个铭文传送门上。*#WHITE#]],
	answers = {
		{"等一下……", action=function(npc, player) player:hasQuest("east-portal"):tannen_tower(player) end},
	}
}

return "welcome"
