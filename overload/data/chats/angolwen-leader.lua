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
	text = [[#LIGHT_GREEN#*一位身材高大的女人站在你的面前，她白皙的皮肤透过她的白色长袍放射出一股惊人的力量。*#WHITE#
我是卡库罗尔的莱娜尼尔。欢迎来到我们的城市。@playerdescriptor.subclass@有什么需要帮忙的么？]],
	answers = {
		{"我寻求一切能帮助我的力量，不是为我自己而是为了东北地区的德斯小镇。", jump="save-derth", cond=function(npc, player) local q = player:hasQuest("lightning-overload") return q and q:isCompleted("saved-derth") and not q:isCompleted("tempest-located") and not q:isStatus(q.DONE) end},
		{"我准备好了，送我去厄奇斯！", jump="teleport-urkis", cond=function(npc, player) local q = player:hasQuest("lightning-overload") return q and not q:isEnded("tempest-located") and q:isCompleted("tempest-located") end},
		{"目前没事，抱歉耽误了你的时间，再见我的女士。"},
	}
}

newChat{ id="save-derth",
	text = [[是的，我们已经注意到了那里发生的破坏。我已经派了几个朋友去驱散那里的乌云，不过真正的威胁并不在那里。
造成这场混乱的是厄奇斯。他是一个风暴术士，能够操纵暴风雨的强大元素法师。
几年前他离开安格利文独自流浪。起初他保持低调，我们也就没采取行动，不过现在看来我们没有选择了。
净化天空需要花费不少时间，同时，假如你乐意的话，我们会传送你到厄奇斯的老巢帮我们直接对付他。
坦白的说，我们送你去的地方，很可能就是一个死亡陷阱，而且我们没有办法再把你从他的巢穴里传送出去，因为他的老巢在岱卡拉山脉的最高峰。]],
	answers = {
		{"我要做些准备工作，我马上就回来。", action=function(npc, player) player:setQuestStatus("lightning-overload", engine.Quest.COMPLETED, "tempest-located") end},
		{"我准备好了，传送我过去吧。我不会再让德斯人民遭受灾难了。", action=function(npc, player)
			player:setQuestStatus("lightning-overload", engine.Quest.COMPLETED, "tempest-located")
			player:hasQuest("lightning-overload"):teleport_urkis()
			game:unlockBackground("linaniil", "Archmage Linaniil")
		end},
	}
}

newChat{ id="teleport-urkis",
	text = [[祝你好运，愿安格利文的祝福与你同在。]],
	answers = {
		{"谢谢。", action=function(npc, player)
			player:hasQuest("lightning-overload"):teleport_urkis()
			game:unlockBackground("linaniil", "Archmage Linaniil")
		end},
	}
}

return "welcome"
