-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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

local popup = function(npc, player)
	npc:doEmote("Vengeance for...  companions...", 90, colors.BLUE)
end

newChat{ id="welcome",
	text = [[As the ]]..kind..[[ falls dead, bubbles start forming beneath you, then frothing as the water grows uncomfortably warm.
#AQUAMARINE#"Thank you...  interloper..."#WHITE# a low voice rumbles.
#AQUAMARINE#"Two obstacles to my rule of the sea...  too cowardly to fight themselves for me to finish off the victor..."#WHITE#
A few meters away, you see the bubbles combining and congregating around a transparent form, invisible before and now visible only by the water boiling around it.
#AQUAMARINE#"How convenient...  so much Sher'Tul magic for my taking...  magic to turn against its creators...  but now... one new obstacle...  one last great warrior under the waves..."#WHITE#]],
	answers = {
		{"The oceans are yours.  The people of Eyal gave up sea travel ages ago!", jump="a"},
		{"You're the new Lord of the Seas?  What would you have me do?", jump="b"},
		{"The seas of Eyal shall know no lord, foul demon!  The chaos and death ends now!", jump="c"},
		{"Stop bubbling and start dying, you overgrown tea-kettle!  Your treasures are mine!", action=popup},
	}
}

newChat{ id="a",
	text = [[The frothing form frowns.
#AQUAMARINE#"Will come to the surface eventually...  you may be stronger then..."#WHITE#
The bubbles flare up, as a wave of heat emanates from the demon.
#AQUAMARINE#"No reason to wait..."#WHITE#]],
	answers = {
		{"#LIGHT_GREEN#[fight]#WHITE#", action=popup},
	}
}

newChat{ id="b",
	text = [[You did not think it possible for an amorphous mass of bubbles to scowl.
#AQUAMARINE#"]]..(kind == "naga" and "Traitor" or "Murderer")..[[ to the Naloren...  traitor to Ukllmswwik...  I am no fool... "#WHITE#
A jet of boiling water barely misses you, dissipating into bubbles above your head.
#AQUAMARINE#"Your 'loyalty...' would give me their fate..."#WHITE#
The frothing and bubbling around him grows to new heights as he charges you!]],
	answers = {
		{"#LIGHT_GREEN#[fight]#WHITE#", action=popup},
	}
}

newChat{ id="c",
	text = [[He chuckles, bubbles bursting from his mouth with every laugh.
#AQUAMARINE#"So now you feign altruism...  were their deaths just indecision?...  I'll fix that...  scalding or drowning...  your choice..."#WHITE#
The sound of laughter fades under the roaring of water boiling around him as he charges you!]],
	answers = {
		{"#LIGHT_GREEN#[fight]#WHITE#", action=popup},
	}
}

return "welcome"