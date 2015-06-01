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
	text = [[#LIGHT_GREEN#*在恶魔蜘蛛倒下之后你看到什么东西……在它的胃里蠕动！在它的胃炸开之后，一个高大黝黑的男子从炸碎的内脏里走了出来，全身围绕着金光。*#WHITE#
感谢太阳之灵！我以为我再也见不到一个友善的面孔了！
谢谢你，我是瑞西姆，我欠你一份人情。
]],
	answers = {
		{"我是你妻子派来的，她很担心你。", jump="leave"},
	}
}

newChat{ id="leave",
	text = [[啊～我亲爱的！
	好吧，现在我自由了，我会开启一个到晨曦之门的传送门。我想我这辈子再也不想见到蜘蛛了。]],
	answers = {
		{"请带路！", action=function(npc, player) player:hasQuest("spydric-infestation"):portal_back(player) end},
	}
}

return "welcome"
