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
	action = function(npc, player) npc.talked_times = (npc.talked_times or 0) + 1 end,
	text = [[@playername@，很高兴再次见到你！呃。。我们以前见过面么？]],
	answers = {
		{"再见，伟大的守护者。"},
		{"是的，我们是第一次见面。", jump="first", cond=function(npc, player) return not npc.talked_times end},
	}
}

newChat{ id="first",
	text = [[啊，对你来说也许是的，不过对我来说可不是。
听着，某一天你会再次遇到我，不过那不是现在的我。如果你见到他，那他一定是过去的我。
记住这一点很重要：不要告诉那个以前的我有关现在的我的事，明白么？]],
	answers = {
		{"我想这。。。"},
		{"是，伟大的守护者。"},
	}
}

return "welcome"
