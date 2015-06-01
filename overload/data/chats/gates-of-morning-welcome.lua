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
	text = [[#LIGHT_GREEN#*在你面前站着一位穿着金光闪闪铠甲的美丽女士。*#WHITE#
站住！陌生人！你是从哪里来的？晨曦之门是这块大陆最后的自由圣地，你到底是谁？你是一个间谍么？]],
	answers = {
		{"我的女士，没错对于这个大陆来说我的确是一个陌生人，我来自西方，马基·埃亚尔。", jump="from",
		  cond=function(npc, player) return player:hasQuest("strange-new-world") and player:hasQuest("strange-new-world"):isCompleted("helped-fillarel") end},
		{"抱歉，我得走了！"},
	}
}

newChat{ id="from",
	text = [[马基·埃亚尔！我们的人民尝试了很多年与你们取得联系，但都失败了。
不管怎样，你来这里是干什么的？]],
	answers = {
		{"好像我在这块陌生的大陆上迷路了。#LIGHT_GREEN#*告诉她关于你追杀兽人并遭遇了菲拉瑞尔的事。*#WHITE#", jump="orcs"},
		{"太阳骑士？你是什么意思？我并不知道我是从哪里来的。", jump="sun-paladins", cond=function() return profile.mod.allow_build.divine_sun_paladin end},
	}
}

newChat{ id="sun-paladins",
	text = [[我们是太阳堡垒里强大的战士，汲取太阳的力量，并将其注入到我们的军事训练中。
数百年来，我们一直为了人民的自由与兽人战斗，我们的成员人数在不断减少，不过我们会战斗至最后一刻。]],
	answers = {
		{"你的精神十分高贵，我的女士。", jump="from"},
	}
}

newChat{ id="orcs",
	text = [[兽人！啊！那你非常走运，这个大陆到处都是兽人，他们组成了兽人部落，有传言，他们的首领非常强大。
他们在这片大陆上四处劫掠，不断袭击我们。
@playername@，你已经帮了我们一个忙了，欢迎你来到晨曦之门，你是我们太阳堡垒的朋友。]],
	answers = {
		{"谢谢你，我的女士。", action=function(npc, player)
			world:gainAchievement("STRANGE_NEW_WORLD", game.player)
			player:setQuestStatus("strange-new-world", engine.Quest.DONE)
			local spot = game.level:pickSpot{type="npc", subtype="aeryn-main"}
			npc:move(spot.x, spot.y, true)
			npc.can_talk = "gates-of-morning-main"
		end},
	}
}

return "welcome"
