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
	template = [[#LIGHT_GREEN#*Entering the room, you see two massive ogres standing guard, blinking as though awakened from a long sleep. They see you, and immediately snap to attention. The one on the right speaks:*#WHITE#
YOU!  Name, rank, and identification.  NOW.
]],
	answers = {
		{"My what?"},
		{"[attack]"},
	}
}

newChat{ id="nargol-scum",
	template = [[#LIGHT_GREEN#*Entering the room, you see two massive ogres standing guard, blinking as though awakened from a long sleep. They see you, and immediately draw their weapons.]],
	answers = {
		{"[attack]", action=function(npc, player) npc:doEmote("#CRIMSON#NARGOL SCUM!  WE'RE UNDER ATTACK!", 120) end},
	}
}

newChat{ id="conclave",
	template = [[#LIGHT_GREEN#*Entering the room, you see two massive ogres standing guard, blinking as though awakened from a long sleep. They see you, and immediately snap to attention. The one on the right speaks:*#WHITE#
Ah!  Reinforcements!  I don't know how long it's been, but I'll get Astelrid up here to--  wait a minute, where are the rest of them?  #LIGHT_GREEN#*He frowns.*#WHITE# What's your identification number?
]],
	answers = {
		{"Wait! The war's over! It's been thousands of years, the Conclave doesn't exist anymore!", jump="angry-conclave"},
		{"[attack]"},
	}
}

newChat{ id="angry-conclave",
	text = [[#LIGHT_GREEN#*They look at each other and scowl, drawing their weapons.  The one on the left growls:*#WHITE#
LIES!  The Conclave could not have lost!  I don't know who you are, but we can't afford witnesses!
]],
	answers = {
		{"[attack]"},
	}
}

if (player.descriptor.race == "Halfling") then
	return "nargol-scum"
elseif (player:findInAllInventoriesBy('define_as', 'CONCLAVE_ROBE') and player:findInAllInventoriesBy('define_as', 'CONCLAVE_ROBE').wielded and (player.descriptor.race == "Human" or player.descriptor.subrace == "Ogre")) then
	return "conclave"
else
	return "welcome"
end
