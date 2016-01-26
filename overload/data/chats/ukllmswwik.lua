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

-----------------------------------------------------------------------
-- Default
-----------------------------------------------------------------------
if not game.player:isQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "drake-story") then

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*@npcname@的低沉嗓音在山洞里发出隆隆的回响*#WHITE#
这里是我的地盘，我会毫不客气地对付任何入侵者，你到这里想干什么？]],
	answers = {
		{"我是来杀死你然后抢夺你的财宝的，死吧，该死的杂鱼！", action=attack("死吧！")},
		{"我无意闯入这里，我会离开的。", jump="quest"},
	}
}

newChat{ id="quest",
	text = [[等下！你看上去有点价值，让我告诉你一个故事。
在派尔纪，世界被魔法大爆炸的余波撕裂，马基·埃亚尔的一部分大陆架被撕裂出去漂向了海洋。
纳鲁精灵种族灭亡了……至少世界上的人都这么认为。事实上他们之中的一些人使用古代夏·图尔的魔法存活了下来，他们转而在水下生活。
他们现在被称为娜迦，他们生活在马基·埃亚尔和远东大陆之间的海洋深处。
他们中的一个，萨拉苏尔，违抗了他的使命，妄图控制整个水上和水下世界，他发现了一个有可能残留有夏·图尔遗迹的古代神庙，叫做造物者神庙。
他相信可以利用它来#{italic}#进化#{normal}#娜迦。
但是他陷入了疯狂，把一切水下智慧生物都视为对他的威胁，包括我自己。
我不能离开这个圣所，但是也许你能帮我结果了他？
毕竟，算是对他疯狂的一种宽恕吧。]],
	answers = {
		{"我还是要杀了你，夺取你的财宝！", action=attack("死吧！")},
		{"我会照着你的话去做，但是去哪儿找他呢？", jump="givequest"},
		{"这似乎不是明智之举，很抱歉，我必须拒绝。", action=function(npc, player) player:grantQuest("temple-of-creation") player:setQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "drake-story") player:setQuestStatus("temple-of-creation", engine.Quest.FAILED) end},
	}
}

newChat{ id="givequest",
	text = [[我可以为你打开一道传送门，抵达他在西部海洋的巢穴，不过我提醒你：传送是单程的，我没法带你回来，你必须自己去想办法找到返回的路。]],
	answers = {
		{"好的。", action=function(npc, player) player:grantQuest("temple-of-creation") player:setQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "drake-story") end},
		{"这是个陷阱！再见！", action=function(npc, player) player:grantQuest("temple-of-creation") player:setQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "drake-story") player:setQuestStatus("temple-of-creation", engine.Quest.FAILED) end},
	}
}


-----------------------------------------------------------------------
-- Coming back later
-----------------------------------------------------------------------
else
newChat{ id="welcome",
	text = [[嗯？]],
	answers = {
		{"[攻击]", action=attack("背叛者！")},
		{"我需要你的财宝，水下怪物！", action=attack("哦，你确定？好啊，来拿啊！")},
		{"我询问过萨拉苏尔，他貌似不是个坏人，也没疯。", jump="slasul_friend", cond=function(npc, player) return player:isQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "slasul-story") and not player:isQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "kill-slasul") end},
		{"告辞了，巨龙。"},
	}
}

newChat{ id="slasul_friend",
	text = [[#LIGHT_GREEN#*@npcname@ 发出了怒吼！*#WHITE# 你居然听信这个疯子娜迦的谎言！
你也一定也堕落了！]],
	answers = {
		{"[攻击]", action=attack("不要管巨龙的闲事！")},
		{"#LIGHT_GREEN#*你摇摇头。*#LAST#好吧，我被他骗了，我不是你的敌人。", jump="last_chance", cond=function(npc, player) return rng.percent(30 + player:getLck()) end},
	}
}

newChat{ id="last_chance",
	text = [[#LIGHT_GREEN#*@npcname@ 冷静了下来！*#WHITE# 好吧，他的确是个骗子，那现在去完成你的任务吧，要不然就不要回来了！]],
	answers = {
		{"谢谢你。"},
	}
}

end

return "welcome"

