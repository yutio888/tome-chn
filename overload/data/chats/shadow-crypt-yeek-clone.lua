-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
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

local cultist = nil
for uid, e in pairs(game.level.entities) do if e.define_as == "CULTIST_RAK_SHOR" then cultist = true end end

if cultist then

newChat{ id="welcome",
	text = [[没时间闲聊了，我的同胞！冲啊！为了维网！]],
	answers = {
		{"[离开]"},
	}
}

else 

newChat{ id="welcome",
	text = [[那个创造了我的愚蠢邪教徒已经死了。我现在应该做什么呢…]],
	answers = {
		{"你就是我，和我一起走吧！", jump="nocome"},
		{"你应该回伊尔克去。", jump="irkkk"},
	}
}

newChat{ id="nocome",
	text = [[我担心这样会让我很困惑的。我觉得我应该回伊尔克去。再见了，我的克隆！]],
	answers = {
		{"克隆？不，你是我的克隆。", jump="clone"},
		{"再见。", action=function(npc, player) npc:disappear() end},
	}
}

newChat{ id="clone",
	text = [[啊……如果你愿意这么想也没问题。反正，我们都是维网的一份子。]],
	answers = {
		{"再见。", action=function(npc, player) npc:disappear() end},
	}
}

newChat{ id="irkkk",
	text = [[我也是这么想的，再见了，我的克隆。]],
	answers = {
		{"克隆？不，你是我的克隆。", jump="clone"},
		{"再见。", action=function(npc, player) npc:disappear() end},
	}
}

end


return "welcome"
