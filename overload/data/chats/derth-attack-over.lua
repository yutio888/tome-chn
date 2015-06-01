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
	text = [[#LIGHT_GREEN#*一个半身人从他的藏身地走了出来。*
#WHITE#你把他们都杀了？现在我们安全了么？噢，真希望你告诉我这只是一场恶梦！]],
	answers = {
		{"别害怕，我已经赶跑了那些怪物。你知道他们是从哪儿来的，想干什么吗？", jump="quest"},
	}
}

newChat{ id="quest",
	text = [[不知道从哪儿来的！从天上！
	我真不知道。我当时正在农田里照看我的庄稼，然后我听到了哭喊声。当我走进村子，我看到了天上的乌云。那些……那些……东西正喷出一道道闪电！]],
	answers = {
		{"好像它们现在不会再来了。我会找到人来帮我弄清楚这些邪恶乌云的来龙去脉的。", jump="quest2"},
	}
}

newChat{ id="quest2",
	text = [[多谢！你今天救了很多人！
我听到有一个传说，说在群山中隐居着一群足智多谋的贤士。也许他们能帮上忙？要是他们真的存在的话……
还有一群被称为什么伊格的号称与魔法战斗的人，那些人怎么不在这儿？！]],
	answers = {
		{"你是指伊格兰斯吧？我就是。", cond=function(npc, player) return player:isQuestStatus("antimagic", engine.Quest.DONE) end, jump="zigur"},
		{"我不会让你死的。", action=function(npc, player) player:hasQuest("lightning-overload"):done_derth() end},
	}
}

newChat{ id="zigur",
	text = [[那就对这邪恶的魔法做点什么吧！]],
	answers = {
		{"我会的！", action=function(npc, player) player:hasQuest("lightning-overload"):done_derth() end},
	}
}

return "welcome"
