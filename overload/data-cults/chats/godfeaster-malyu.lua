-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2018 Nicolas Casalini
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
	text = [[#DARK_SEA_GREEN##{italic}#在你向前移动的时候，你突然发现自己掉进了一个隐藏的消化袋里，它似乎要耗尽你所有的能力！#{normal}##LAST#]],
	answers = {
		{"[试着拳打脚踢]", jump="tryagain", switch_npc=malyu},
		{"[试着拿剑乱砍]", jump="tryagain", switch_npc=malyu},
		{"[试着喊救命]", jump="tryagain", switch_npc=malyu},
	}
}

newChat{ id="tryagain",
	text = [[#DARK_SEA_GREEN##{italic}#在你快要放弃希望的时候，你听到了切开东西的声音。#{normal}##LAST#
有人在里面吗？]],
	answers = {
		{"是谁…什么…对！我在里面", jump="saved"},
	}
}

newChat{ id="saved",
	text = [[#DARK_SEA_GREEN##{italic}#当袋子被切破开来，你恢复了你的能力。你看到了救你的人是一个冒险家，她好像也被噬神者吞下了。#{normal}##LAST#
	这个东西也吃了你？嘿，至少你有一个伴了。我的名字是Malyu，我在这里被困了几天了，不得不独自面对这一切。我本来准备破坏这个东西的大脑，结果遇到了你。我们一起离开这个地方怎么样？
]],
	answers = {
		{"感谢你的帮助，你救了我。我们一起杀了这个怪物，逃出去吧！", action=function(npc, player)
			game.zone:addEntity(game.level, npc, "actor", popx, popy)
			player:removeEffect(player.EFF_GODFEASTER_EVENT_BLINDED)
			npc.ai_state.tactic_leash = 20
			npc.faction = player.faction
			npc:forceLevelup(player.level)
			game.party:addMember(npc, {
				control="order",
				type="adventurer",
				title="Malyu",
				orders = {target=true, leash=true},
				leave_level = function(self, def) game:onTickEnd(function()
					if game.to_re_add_actors and game.to_re_add_actors[self] then game.to_re_add_actors[self] = nil end
					game.party:removeMember(self)
					if self:attr("dead") then return end
					local chat = require("engine.Chat").new("cults+godfeaster-malyu-escaped", self, game.player)
					chat:invoke()
				end) end,
			})
		end},
	}
}

return "welcome"
