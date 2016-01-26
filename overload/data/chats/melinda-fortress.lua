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

local ql = game.player:hasQuest("love-melinda")
local set = function(what) return function(npc, player) ql:setStatus(ql.COMPLETED, "chat-"..what) end end
local isNotSet = function(what) return function(npc, player) return not ql:isCompleted("chat-"..what) end end
local melinda = game.level:findEntity{define_as="MELINDA_NPC"}
local butler = game.level:findEntity{define_as="BUTLER"}
print("===", butler)

newChat{ id="welcome",
	text = [[嗨亲爱的！]],
	answers = {
		{"#LIGHT_GREEN#[亲吻她]#WHITE#"},
		{"你过得好么？?", cond=isNotSet"settle", action=set"settle", jump="settle"},
	}
}

ql.wants_to = ql.wants_to or "derth"
local dest = {
	derth = [[我想在德斯镇开店？]],
	magic = [[我想去安格利文学魔法?]],
	antimagic = [[我想去伊格兰斯训练?]],
}

newChat{ id="settle",
	text = [[好吧，那个通道确实有些#{bold}#可怕#{normal}#，不过那个长相奇怪的管家说那是唯一的路。
现在我觉得好多了。
不过，呆久了还是觉得有些无聊。
你还记得么,我曾经说过“]]..dest[ql.wants_to]..[[”，或许能想个办法，白天出去，晚上再回来？]],
	answers = {
		{"当然可以，我相信我们能做到。堡垒幻影，能为她制造一个传送门么？", jump="portal", switch_npc=butler},
	}
}

newChat{ id="portal",
	text = [[是的，主人。我马上做。
她将能够无声无息的来往于俩地之间。]],
	answers = {
		{"很好。", jump="portal2", switch_npc=melinda, action=function(npc, player)
			local spot = game.level:pickSpot{type="portal-melinda", subtype="back"}
			if spot then
				local g = game.zone:makeEntityByName(game.level, "terrain", "TELEPORT_OUT_MELINDA")
				game.zone:addEntity(game.level, g, "terrain", spot.x, spot.y)
			end
		end},
	}
}

newChat{ id="portal2",
	text = [[噢，太棒了！谢谢！属于我自己的通道，属于我自己的人生。]],
	answers = {
		{"只要你过得幸福，我什么都愿意做。", jump="reward"},
	}
}

newChat{ id="reward",
	text = [[#LIGHT_GREEN#*看上去充满魅力，梅琳达走近了你*#WHITE#
亲爱的，我们上一次是什么时候?]],
	answers = {
		{"我都忘了，你能帮我想起来么？#LIGHT_GREEN#[你调皮地笑着]", action=function(npc, player)
			player:setQuestStatus("love-melinda", engine.Quest.COMPLETED, "portal-done")
			world:gainAchievement("MELINDA_LUCKY", player)
			game:setAllowedBuild("cosmetic_bikini", true)
		end},
	}
}

return "welcome"
