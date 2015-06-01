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

local p = game.party:findMember{main=true}
if p:attr("forbid_arcane") then

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*在你面前站着一个年轻人，看上去像是一个法师学徒。*#WHITE#
你好……#LIGHT_GREEN#*他盯着你看了一会，然后撒腿就跑！*#WHITE#
请不要杀我！]],
	answers = {
		{"……", action = function(npc, player) npc:die() end,
},
	}
}
return "welcome"

end

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*在你面前站着一个年轻人，看上去像是一个法师学徒。*#WHITE#
你好啊，旅行者！]],
	answers = {
		{"一个法师学徒在荒郊野外干什么？", jump="quest", cond=function(npc, player) return not player:hasQuest("mage-apprentice") end},
		{"我发现了这件充满奥术能量的神器，看上去很强大，应该够了吧？",
			jump="unique",
			cond=function(npc, player) return player:hasQuest("mage-apprentice") and player:hasQuest("mage-apprentice"):can_offer_unique(player) end,
			action=function(npc, player, dialog) player:hasQuest("mage-apprentice"):collect_staff_unique(npc, player, dialog) end
		},
		-- Reward for non-mages: access to Angolwen
		{"你找到足够的魔法物品了吗？",
			jump="thanks",
			cond=function(npc, player) return player:hasQuest("mage-apprentice") and player:hasQuest("mage-apprentice"):isCompleted() and not player:knowTalent(player.T_TELEPORT_ANGOLWEN) end,
		},
		-- Reward for mages: upgrade a talent mastery
		{"你找到足够的魔法物品了吗？",
			jump="thanks_mage",
			cond=function(npc, player) return player:hasQuest("mage-apprentice") and player:hasQuest("mage-apprentice"):isCompleted() and player:knowTalent(player.T_TELEPORT_ANGOLWEN) end,
		},
--		{"你有什么东西卖么？", jump="store"},
		{"抱歉我得走了！"},
	}
}

newChat{ id="quest",
	text = [[啊，我的故事说来让人伤心……算了，我不应该打扰你的，我的朋友。]],
	answers = {
		{"没关系的，告诉我吧！", jump="quest2"},
		{"好的，那么再见。"},
	}
}
newChat{ id="quest2",
	text = [[好吧，假如你坚持的话……
我是个法师学徒，你可能已经看出来了。我的目标是被安格利文的人接纳然后他们教给我奥术的秘密。]],
	answers = {
		{"安格利文的人是谁？", jump="quest3", cond=function(npc, player) return player.faction ~= "angolwen" end,},
		{"啊，对的，安格利文，很多年来我一直称呼它为我的家……", jump="quest3_mage", cond=function(npc, player) return player.faction == "angolwen" end,},
		{"那么，祝你好运，再见！"},
	}
}
newChat{ id="quest3",
	text = [[他们是世界上仅存的法……唉呀，我好像说了什么不该说的话……抱歉，我的朋友……
无论如何，我必须得搜集些物品。这些都没问题了，不过我还需要找到一件充满奥术能量的神器。我想你不会恰巧有一件吧……当然如果你有的话，请告诉我 ！]],
	answers = {
		{"好的，我记住了！", action=function(npc, player) player:grantQuest("mage-apprentice") end},
		{"算了吧，再见！"},
	}
}
newChat{ id="quest3_mage",
	text = [[我希望我也是……
无论如何，我必须得搜集些物品。这些都没问题了，不过我还需要找到一件充满奥术能量的神器。我想你不会恰巧有一件吧……当然如果你有的话，请告诉我 ！]],
	answers = {
		{"好的，我记住了！", action=function(npc, player) player:grantQuest("mage-apprentice") end},
		{"算了吧，再见！"},
	}
}

newChat{ id="unique",
	text = [[让我试试看。
喔，是的，我的朋友，的确是一件强力神器！我想就凭这个我应该可以交差了！非常感谢！]],
	answers = {
		{"好的，对我来说没什么用。", jump="welcome"},
	}
}

newChat{ id="thanks",
	text = [[哦……对，我可以重新返回安格利…，呃……我想我现在可以告诉你了，你帮了我这么多我应该告诉你。
在魔法狩猎的那些黑暗年代里，几千年前，莱娜尼尔，卡尔·库尔的大法师，担心魔法会在她们那一代人身上灭绝，人们需要的这些魔法会从这个世界上消失。
于是她秘密安置了一个隐秘的地方继续传承魔法。
她执行了她的计划，她手下的人在西部的群山之中建立了一个叫做安格利文的小镇。#LIGHT_GREEN#*他在你的地图上做了一个记号，然后为你开启了一个传送门。*#WHITE#
只有少部分人会被那里的人接受，我会想办法让你进去的。]],
	answers = {
		{"哦！这个秘密的地方怎么能保持隐秘这么长时间，真的很有趣，谢谢你对我的信任。",
			action = function(npc, player)
				player:hasQuest("mage-apprentice"):access_angolwen(player)
				npc:die()
			end,
		},
	}
}

newChat{ id="thanks_mage",
	text = [[哦……对！我太高兴了！我终于可以回到安格利文了，也许我们会在那里再次见面。
请收下这枚戒指，曾经它对我很有用。]],
	answers = {
		{"谢谢，祝你好运！",
			action = function(npc, player)
				player:hasQuest("mage-apprentice"):ring_gift(player)
				npc:die()
			end,
		},
	}
}

return "welcome"
