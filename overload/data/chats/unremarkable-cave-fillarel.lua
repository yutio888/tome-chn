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

newChat{ id="welcome",
	text = [[谢谢你，@playername@。不得不承认，你救了我的命。]],
	answers = {
		{"很荣幸，但你是否可以告诉我你在这个黑暗的地方干什么？", jump="what", cond=function(npc, player) return not player:hasQuest("start-sunwall") end},
		{"很荣幸，我已经流浪几个月了，不过我能够感觉到，这里就是我的故乡！", jump="back", cond=function(npc, player) return player:hasQuest("start-sunwall") end},
	}
}

newChat{ id="what",
	text = [[我是一位星月术士，操纵太阳和月亮的神力的法师。我和一群太阳骑士一起对抗邪恶。我们来自东部的晨曦之门。
我的伙伴们都被兽人杀死了，我也差点丧命，再次感谢你的帮助。]],
	answers = {
		{"我的荣幸，不过我有个请求？我不是这个大陆的人，我使用了钢铁王座地下深处兽人保护的远古传送门，然后就到了这里。", action=function(npc, player) game:setAllowedBuild("divine") game:setAllowedBuild("divine_anorithil", true) end, jump="sunwall"},
	}
}

newChat{ id="sunwall",
	text = [[是的，我也注意到了你不是这里的人，晨曦之门，这座兽人领地中仅存的自由基地，将是你的唯一希望，当你离开洞穴，往东南方走就可以到达那里。
告诉高阶太阳骑士艾伦你碰到我的事，我会留下口信让他们给你放行。]],
	answers = {
		{"谢谢你，我会找艾伦谈谈的。", action=function(npc, player) game.player:setQuestStatus("strange-new-world", engine.Quest.COMPLETED, "helped-fillarel") end},
	}
}

newChat{ id="back",
	text = [[流浪？等一下，你是……你是 @playername@！我们都以为你在娜迦传送门爆炸的时候死了！
感谢你的勇气，晨曦之门能够保存完好。
你应该马上去那里。]],
	answers = {
		{"恐怕我得告诉你一些坏消息，兽人正筹划着什么阴谋，祝你好运，我的女士。"},
	}
}

return "welcome"
