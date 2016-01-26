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
	text = [[#LIGHT_GREEN#*在你面前站着一只可爱的小猫咪。它似乎饿了，眼泪汪汪地瞅着你。*#WHITE#
喵呜...
]],
	answers = {
		{"猫咪真可爱!", jump="kitty"},
		{"我可没时间浪费在猫身上!"},
	}
}

newChat{ id="kitty",
	text = [[#LIGHT_GREEN#*它轻轻地蹭着你的腿，咕噜咕噜地叫着。*#WHITE#
呜呜...
]],
	answers = {
		{"小猫，你想吃点东西么？我这里正好有半截巨魔肠子，你要么？ #LIGHT_GREEN#[喂给它吃]#WHITE#", jump="pet", cond=function(npc, player) return game.party:hasIngredient("TROLL_INTESTINE") end},
		{"小猫，抱歉，我帮不了你。"},		
	}
}

newChat{ id="pet",
	text = [[#LIGHT_GREEN#*它全部吃光了，看起来很开心。过了一会，它就跑开了。*#WHITE#]],
	answers = {
		{"#LIGHT_GREEN#[离开]", action=function(npc, player)
			game.state.kitty_fed = true
		end},		
	}
}

return "welcome"
