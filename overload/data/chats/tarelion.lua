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
	text = [[我说，那边那个，对对，就是你，年轻人！
你看上去像一个冒险者之类的，大不了算是一个在外面世界闯荡的小子。好吧，别忘了为这个城里最好的图书馆捐点钱。这个世界的有钱人大多数是好人，但是要是我们没有知识赐予力量怎么办？所有搜集的资金都会直接用于进一步研究。没有其他理由了，对么？]],
	answers = {
		{"啊，是的，当然……我得继续赶路了。"},
		{"打住！你……你不就是那个荒野之中的法师学徒么？", cond=function(npc, player) return player:isQuestStatus("mage-apprentice", engine.Quest.DONE) and player:getCun() >= 35 end, jump="apprentice"},
	}
}

newChat{ id="apprentice",
	text = [[你说什么？你这个傲慢的家伙！的确我有时会心血来潮假扮成一个学徒到处旅行，这样在我的研修旅行中就不会引人注意。我会搜集一切对安格利文有价值的东西，多多益善。不过我告诉你，确实有人借此来嘲笑我！]],
	answers = {
		{"啊，是的，当然……我得继续赶路了。"},
	}
}

return "welcome"
