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
local q = game.player:hasQuest("kryl-feijan-escape")
local qs = game.player:hasQuest("shertul-fortress")
local ql = game.player:hasQuest("love-melinda")

if ql and ql:isStatus(q.COMPLETED, "death-beach") then

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*门半掩着，一个男人的声音传了出来，他的声音听上去很悲伤。*#WHITE#
抱歉……商店已经关门了……]],
	answers = {
		{"[leave]"},
	}
}

elseif not q or not q:isStatus(q.DONE) then

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*门半掩着，一个男人的声音传了出来，他的声音听上去很悲伤。*#WHITE#
抱歉……商店已经关门了……]],
	answers = {
		{"[离开]"},
	}
}

else

------------------------------------------------------------------
-- Saved
------------------------------------------------------------------

newChat{ id="welcome",
	text = [[@playername@! 我女儿的救命恩人!]],
	answers = {
		{"你好，我就是来看望一下梅琳达的。", jump="reward", cond=function(npc, player) return not npc.rewarded_for_saving_melinda end, action=function(npc, player) npc.rewarded_for_saving_melinda = true end},
		{"你好，我想和梅琳达谈谈。", jump="rewelcome", switch_npc={name="Melinda"}, cond=function(npc, player) return ql and not ql:isCompleted("moved-in") and not ql.inlove end},
		{"你好，我想和梅琳达谈谈。", jump="rewelcome-love", switch_npc={name="Melinda"}, cond=function(npc, player) return ql and not ql:isCompleted("moved-in") and ql.inlove end},
		{"抱歉，我必须得走了！"},
	}
}

newChat{ id="reward",
	text = [[请带上这个。没什么比我孩子的生命更重要了。哦，她想亲自表达她对你的谢意。我去叫她出来。]],
	answers = {
		{"谢谢。", jump="melinda", switch_npc={name="Melinda"}, action=function(npc, player)
			local ro = game.zone:makeEntity(game.level, "object", {unique=true, not_properties={"lore"}}, nil, true)
			if ro then
				ro:identify(true)
				game.logPlayer(player, "梅琳达的父亲交给了你: %s", ro:getName{do_color=true})
				game.zone:addEntity(game.level, ro, "object")
				player:addObject(player:getInven("INVEN"), ro)
				game._chronoworlds = nil
			end
			player:grantQuest("love-melinda")
			ql = player:hasQuest("love-melinda")
		end},
	}
}
newChat{ id="melinda",
	text = [[@playername@! #LIGHT_GREEN#*当她父亲返回商店时，她高兴地跳了起来，给了你一个拥抱。*#WHITE#]],
	answers = {
		{"看到你一切安好真是太好了。你的伤疤看上去也已经痊愈了。", jump="scars", cond=function(npc, player)
			if player:attr("undead") then return false end
			return true
		end,},
		{"很高兴看到你没事，多保重。"},
	}
}

------------------------------------------------------------------
-- Flirting
------------------------------------------------------------------
newChat{ id="scars",
	text = [[是的，基本上好了，尽管晚上有时我还会做噩梦。我觉得心里总不得安宁。
不过，这比起你救我之前的处境，确实好多了!]],
	answers = {
		{"如果在我的旅程中能帮到你的话，我会尽力的。", quick_reply="谢谢，你真是个好人。"},
		{"那么，你现在有什么计划么？", jump="plans"},
	}
}
newChat{ id="rewelcome",
	text = [[Hi @playername@!我感觉好多了，现在我甚至觉得精神焕发...]],
	answers = {
		{"那么，你有什么计划么?", jump="plans"},
		{"呃，我觉得你也许喜欢和我出去走走 ...", jump="hiton", cond=function() return not ql.inlove and not ql.nolove end},
	}
}
newChat{ id="rewelcome-love",
	text = [[#LIGHT_GREEN#*梅琳达出现在门口，亲吻了你*#WHITE#
亲爱的，见到你真好!]],
	answers = {
		{"我仍在为那天在海滩的事情找个解释。"},
		{"关于海滩那件事，我想我发现了什么", jump="home1" , cond=function() return ql:isStatus(engine.Quest.COMPLETED, "can_come_fortress") end},
	}
}

local p = game:getPlayer(true)
local is_am = p:attr("forbid_arcane")
local is_mage = (p.faction == "angolwen") or p:isQuestStatus("mage-apprentice", engine.Quest.DONE)
newChat{ id="plans",
	text = [[我不知道，我的父亲不会让我出门的，除非我痊愈了。但我总想做许多事情。
这也许是我为什么会被关在地窖的原因吧，我想亲眼看看这个世界。
我的父亲给了我一些钱，这样我就能掌握自己的未来。我在德斯镇有几个朋友，或许，我能在那里开一家小商店。]]..(
is_am and
	[[我看到了你是怎样对抗那些堕落法师的，看到了你摧毁他们的邪恶魔法的方法。我也想做同样的事，这样的话，这种噩梦就不会再上演了。]]
or (is_mage and
	[[或许，呃，我可以相信你吧，我一直想学魔法。是真正的魔法，而不是炼金术士的小把戏！
我听说过一个秘密的地方，叫做安格利文，在那里我就能学习魔法。]]
or [[]])),
	answers = (not is_am and not is_mage) and {
		{"德斯镇有自己的起起落落，但我相信像你这样的聪明女孩一定能生活下去。", action=function() ql.wants_to = "derth" end, quick_reply="谢谢!"},
	} or {
		{"德斯镇有自己的起起落落，但我相信像你这样的聪明女孩一定能生活下去。", action=function() ql.wants_to = "derth" end, quick_reply="谢谢!"},
		{"你希望加入我们高尚的反魔组织么？太好了！我会和他们说的。", action=function() ql.wants_to = "antimagic" end, cond=function() return is_am end, quick_reply="那真是太好了!"},
		{"我正巧在安格利文还比较受欢迎，我会帮你带话的。", action=function() ql.wants_to = "magic" end, cond=function() return is_mage end, quick_reply="那真是太好了!"},
	}
}

newChat{ id="hiton",
	text = [[什么？就因为你救了我的命，我就得把自己给你？]],
	answers = {
		{"为什么对我不感兴趣呢？我可是个很好的"..(p.female and "女孩" or "家伙")..".", quick_reply="呃，不好意思，我听到我的父亲在喊我，再见。", action=function() ql.nolove = true end},
		{"等一会，我只是 ...", jump="reassurance"},
	}
}

newChat{ id="reassurance",
	text = [[#LIGHT_GREEN#*她兴奋地看着你*#WHITE#
开玩笑的，我很喜欢!]],
	answers = {
		{"#LIGHT_GREEN#[朝她走了过去]#WHITE#我们去南边旅行吧，从魔法大爆炸之痕的海岸开始，那是一段美好的风景。", action=function() ql.inlove = true ql:toBeach() end},
		{"真的只是开玩笑，再见了!", quick_reply="但是……好吧，再见。", action=function() ql.nolove = true end},
	}
}

newChat{ id="hug",
	text = [[#LIGHT_GREEN#*你把梅琳达紧紧拥在怀里，身体的接触使你感受到她的体温照亮了你的内心。*#WHITE#
在你的怀抱中我觉得很安全，我知道你要走了，求求你，答应我你会尽快回来看我，拥抱我。]],
	answers = {
		{"我想我很乐意这么做。#LIGHT_GREEN#[亲吻她]#WHITE#", action=function(npc, player)  end},
		{"对你的思念会伴随我在黑暗中前行。#LIGHT_GREEN#[亲吻她]#WHITE#", action=function(npc, player) player:grantQuest("love-melinda") end},
		{"噢，抱歉，我想你误会了。我只是想安慰你。", quick_reply="对不起，我失态了。那么，再见吧。"},
	}
}

------------------------------------------------------------------
-- Moving in
------------------------------------------------------------------
newChat{ id="home1",
	text = [[#LIGHT_GREEN#*梅琳达面露忧愁*#WHITE#
请帮帮我!]],
	answers = {
		{"呃，不久前，我拥有了一座非常特别的房子... #LIGHT_GREEN#[告诉她关于堡垒的事]#WHITE#", jump="home2"},
	}
}

newChat{ id="home2",
	text = [[一座神秘种族的古代堡垒#{bold}#真不可思议！#{normal}#!
你觉得那会治疗我么?]],
	answers = {
		{"堡垒应该是可以的。我知道，这听上去有一点，呃，不太合适。不过，你应该到那里去住上一小段时间。", jump="home3"},
	}
}

newChat{ id="home3",
	text = [[#LIGHT_GREEN#*她兴奋地看着你*#WHITE#
你的计划终于暴露了！
傻瓜，两个大傻瓜。我当然会去，不仅为了我的健康，也为了和你在一起。
#LIGHT_GREEN#*她温柔地和你接吻*#WHITE#]],
	answers = {
		{"我的女士，如果你愿意，就跟我来吧。#LIGHT_GREEN#[带她去堡垒]", action=function(npc, player)
			game:changeLevel(1, "shertul-fortress", {direct_switch=true})
			player:hasQuest("love-melinda"):spawnFortress(player)
		end},
	}
}

end

return "welcome"
