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
	text = [[刚才发生了什么？！]],
	answers = {
		{"抱歉，刚才我没能保护住你，当你快死时，突然...你周围产生了一道强大的法力冲击波。", jump="next1"},
	}
}

newChat{ id="next1",
	text = [[但我从来没施过法啊！]],
	answers = {
		{"你肯定被污染了...对,那个恶魔！污染还没有被清除干净！", jump="next_am", cond=function(npc, player) return player:attr("forbid_arcane") end},
		{"你身体里还存在着恶魔的污染。", jump="next_notam", cond=function(npc, player) return not player:attr("forbid_arcane") end},
	}
}

newChat{ id="next_am",
	text = [[怎么会！我发誓，什么都不知道，你要相信我！一定要！]],
	answers = {
		{"我相信。伊格兰斯不是杀人狂魔，我们会找到方法来治疗你的，只要你拒绝接受这股枯萎能量。", jump="next2"},
	}
}

newChat{ id="next_notam",
	text = [[天啊!到底发生了什么?!?你一定要帮我!]],
	answers = {
		{"我当然会帮你。我们一起来想办法。", jump="next2"},
	}
}

newChat{ id="next2",
	text = [[我真是幸运，不，不幸... 这是你第二次拯救我了。]],
	answers = {
		{"最近的几个星期里，你对我非常重要，我很乐意这样做。不过，这里不是说话的地方，我们找个安全的地方吧。", jump="next3"},
	}
}

newChat{ id="next3",
	text = [[你说得对！快点离开这。]],
	answers = {
		{"#LIGHT_GREEN#[回到最后的希望]", action=function(npc, player)
			game:changeLevel(1, "town-last-hope", {direct_switch=true})
			player:move(25, 44, true)
		end},
	}
}

return "welcome"
