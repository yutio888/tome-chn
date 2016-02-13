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
	text = [[等一下！]],
	answers = {
		{"大法师泰尔兰？", jump="next1"},
	}
}

newChat{ id="next1",
	text = [[是的， @playername@，我听说你计划到野外去寻找和你一样的冒险家。
这样很好，我们应该多多出去到外面的世界去帮助那里的人们。
说吧，也许你需要一个冒险者来帮助安格利文？]],
	answers = {
		{"也许吧，你想要什么？", jump="next2"},
	}
}

newChat{ id="next2",
	text = [[魔法大爆炸把这个世界分裂成了几个碎片。其中一部分，我们称它为次元浮岛，从这个世界分离了出去，落入了群星之中的无尽虚空。
我们试图使它稳定下来，但是现在它正在向埃亚尔大陆飞来。最近我们在那儿也注意到一些骚动，如果我们任其发展它会撞向埃亚尔大陆造成极大的灾难。
由于我们以前对那块大陆比较熟悉，我们可以将你传送至那里，你需要向三个不稳定的虫洞施放各种攻击性法术使它们稳定下来。
虽然那里的时空很不稳定，它同时也能给你带来好处，你的相位之门法术在那里可以变得完全受你控制。

那么，你认为你可以帮助我们么？]],
	answers = {
		{"是的大法师，把我送去那里！", jump="teleport"},
		{"不行，抱歉，我得走了。", jump="refuse"},
	}
}

newChat{ id="teleport",
	text = [[祝你好运！]],
	answers = {
		{"[传送]", action=function(npc, player) game:changeLevel(1, "abashed-expanse", {direct_switch=true}) end},
	}
}

newChat{ id="refuse",
	text = [[那好吧，祝你旅途顺风，我得找其他人帮我这个忙了。]],
	answers = {
		{"再见。", action=function(npc, player) player:setQuestStatus("start-archmage", engine.Quest.FAILED) end},
	}
}

return "welcome"
