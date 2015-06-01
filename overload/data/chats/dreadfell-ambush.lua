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

newChat{ id="ambush",
	text = [[#VIOLET#*当你从恐惧王座里出来的时候，你遭遇了一队兽人。*
#LAST#你！马上把你手上的法杖给我们！我们会让你死的痛快一点！]],
	answers = {
		{"你说什么？！", jump="what"},
		{"你们想要它干什么？", jump="why"},
		{"#LIGHT_GREEN#[攻击]"},
	}
}

newChat{ id="what",
	text = [[你少装蒜了，攻击！]],
	answers = {
		{"#LIGHT_GREEN#[攻击]"},
	}
}

newChat{ id="why",
	text = [[这和你无关，攻击！]],
	answers = {
		{"#LIGHT_GREEN#[攻击]"},
	}
}

return "ambush"
