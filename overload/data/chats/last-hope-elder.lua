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
	text = [[欢迎你，@playername@，欢迎来到最后的希望。旅行者，你最好抓紧时间，我的时间很宝贵。]],
	answers = {
		{"我在旅途中找到了一根法杖。(#LIGHT_GREEN#*详细说明事情的来龙去脉*#LAST#) 它看上去很古老但拥有强大的力量。我不敢使用它。", jump="found_staff", cond=function(npc, player) return player:isQuestStatus("staff-absorption", engine.Quest.PENDING) end},
		{"追踪这根法杖的时候我到达了远东的一个大陆，只有通过魔法传送门才能到达那儿。刚才我就用这样的一个传送门返回这里，我现在就是来告诉大家如何制造一个类似的传送门从最后的希望通往远东大陆，我相信那里的精灵会很乐意同我们进行贸易往来。", jump="east_portal", cond=function(npc, player) local q = player:hasQuest("east-portal"); return q and not q:isCompleted("talked-elder") end},
		{"没事，抱歉打扰了，再见！"},
	}
}

newChat{ id="found_staff",
	text = [[#LIGHT_GREEN#*他沉默了一段时间*#WHITE# 的确你来这里是对的。
你描述的法杖让我想起了一件在古代有强大力量的神器，能让我看一下么？]],
	answers = {
		{"就是这个。 #LIGHT_GREEN#*告诉他有关被兽人部队伏击的事。*#LAST# 你应该拿着它。我能感受到它的力量，法杖在帝国军队的保护下才是安全的。",
		 jump="given_staff", cond=function(npc, player) return game.party:findInAllPartyInventoriesBy("define_as", "STAFF_ABSORPTION") and player:isQuestStatus("staff-absorption", engine.Quest.COMPLETED, "survived-ukruk") or false end},
		{"抱歉我没能把它带来。 #LIGHT_GREEN#*告诉他有关被兽人部队伏击的事。*",
		 jump="lost_staff", cond=function(npc, player) return player:isQuestStatus("staff-absorption", engine.Quest.COMPLETED, "ambush-died") end},
		{"I had it briefly but have lost it somehow.  It could have been some orcs I encountered ...",
		 jump="lost_staff", fallback=true, cond=function(npc, player) return player:hasQuest("staff-absorption") end},
	}
}

newChat{ id="given_staff",
	text = [[我很惊讶你的力量，能在袭击中活下来可是一项壮举。
关于兽人，这就有点麻烦了。我们已经80年没有见过他们了……难道他们是从远东大陆过来的？
不管怎样，还是非常感谢， @playername@, 感谢你的帮助。]],
	answers = {
		{"谢谢你，阁下。", action=function(npc, player)
			local mem, o, item, inven_id = game.party:findInAllPartyInventoriesBy("define_as", "STAFF_ABSORPTION")
			if mem and o then
				mem:removeObject(inven_id, item, true)
				o:removed()
			end

			player:setQuestStatus("staff-absorption", engine.Quest.DONE)
			world:gainAchievement("A_DANGEROUS_SECRET", player)
		end, jump="orc_hunt"},
	}
}

newChat{ id="lost_staff",
	text = [[兽人？在西部大陆？！这非常令人担忧！我们几乎已经80年没有见到过兽人了，他们肯定是从远东大陆来的……
不过你不必自责，你带来了重要的消息，而且你还能活下来已经很幸运了。]],
	answers = {
		{"谢谢你，阁下。", action=function(npc, player)
			player:setQuestStatus("staff-absorption", engine.Quest.DONE)
			world:gainAchievement("A_DANGEROUS_SECRET", player)
		end, jump="orc_hunt"},
	}
}

newChat{ id="orc_hunt",
	text = [[有来自矮人的传说，在钢铁王座古王国瑞库纳深处可能仍有兽人的踪迹。
我知道你已经经历了很多事，不过我们还是需要一个人去调查一下，确认他们与法杖之间的联系。]],
	answers = {
		{"我会去矿坑那里调查。", action=function(npc, player)
			player:grantQuest("orc-hunt")
		end},
	}
}

newChat{ id="east_portal",
	text = [[真不可思议！对于新商路的开辟，我知道一些富商知道这个消息后肯定会高兴的直流口水。不过你还没告诉我，关于法杖的事情，进行的怎么样了？]],
	answers = {
		{"法杖已经复原，罪犯已经被处决，他们不会再困扰我们了。[告诉他整个事情经过。]", jump="east_portal_winner", cond=function(npc, player) return player:isQuestStatus("high-peak", engine.Quest.DONE) end},
		{"还在继续调查，传送门的建立对于法杖的修复会有极大的帮助。", jump="east_portal_hunt", cond=function(npc, player) return not player:isQuestStatus("high-peak", engine.Quest.DONE) end},
	}
}

newChat{ id="east_portal_winner",
	text = [[太棒了！但是，关于这个有趣的传送门，恐怕很多人早已将古老魔法遗忘了。我只知道在这个大陆上有一个人可能能够帮助你，一个最近才来到最后希望的智者。 他的名字叫泰恩，他自称他是从安格利文来的，那是传说中的神秘魔法港湾，他几个月前刚和一个富商来到这里，他在城市北部边境建造了他的塔楼。我对他了解不多，不过如果他是个可信之人的话，应该是最有可能帮上你的。]],
	answers = {
		{"多谢。", action=function(npc, player) player:setQuestStatus("east-portal", engine.Quest.COMPLETED, "talked-elder") end},
	}
}

newChat{ id="east_portal_hunt",
	text = [[那样的话，我们就长话短说，关于这个有趣的传送门，恐怕很多人早已将古老魔法遗忘了。我只知道在这个大陆上有一个人可能能够帮助你，一个最近才来到最后希望的智者。 他的名字叫泰恩，他自称他是从安格利文来的，那是传说中的神秘魔法港湾，他几个月前刚和一个富商来到这里，他在城市北部边境建造了他的塔楼。我对他了解不多，不过如果他是个可信之人的话，应该是最有可能帮上你的。]],
	answers = {
		{"多谢。", action=function(npc, player) player:setQuestStatus("east-portal", engine.Quest.COMPLETED, "talked-elder") end},
	}
}

return "welcome"
