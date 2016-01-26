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
	text = [[#LIGHT_GREEN#*他跪了下来*#WHITE#
饶恕我吧，饶了我这个可怜的人，我不会再阻止你了，让我走吧！]],
	answers = {
		{"不行！", jump="welcome2"},
	}
}

newChat{ id="welcome2",
	text = [[但……但……你是我的……你……
你还需要我！你想你到外面会怎么样？所有你见到的东西都会想摧毁你。
你虽然很强，但是你不可能对抗所有人！]],
	answers = {
		{"那你的建议呢？", jump="what"},
		{"[杀了他]", action=function(npc, player)
			npc.die = nil
			npc:doEmote("啊啊啊啊嘎……你是独一无二的！注定走向毁灭！", 60)
			npc:die(player)
		end},
	}
}

newChat{ id="what",
	text = [[我可以给你一件斗篷，让别人认不出你的本来面目。
穿着它你的外形看上去就会像一个普通人一样，不会引起别人的注意，这样你就可以干任何你想干的事了。
求求你！]],
	answers = {
		{"谢谢你的帮忙，现在你可以死了。[杀了他]", action=function(npc, player)
			npc.die = nil
			npc:doEmote("啊啊啊啊嘎……你是独一无二的！注定走向毁灭！", 60)
			npc:die(player)
		end},
	}
}

return "welcome"
