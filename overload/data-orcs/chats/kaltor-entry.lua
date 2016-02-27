

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*As you open the door to the shop, you are greeted by a pair of Steam Giant guards, staring at you and holding their steamguns tightly, at the ready but not aimed at you.*#WHITE#
No sudden moves, @playername@. Kaltor's orders are to consider you a customer for now. Try anything foolish, and you'll be a live demonstration for his newest guns instead.  Understand?]],
	answers = {
		{"I have gold, you have equipment. This doesn't need to be any more complicated than that.", jump="ok"},
		{"Those are some pretty fancy guns. Think it'll be hard to get your blood out of the gears?", jump="fight"},
	}
}

newChat{ id="ok",
	text = [[#LIGHT_GREEN#*She smiles, relieved but also slightly disappointed.*#WHITE#
Couldn't have said it better myself. Come on in - and try not to scare the other patrons.]],
	answers = {
		{"[enter]"},
	}
}

newChat{ id="fight",
	text = [[Good luck with that, savage.
#LIGHT_GREEN#*She smirks, and pulls a cord on the wall beside her as her and her partner duck behind cover; a loud bell rings, and you hear a commotion from further inside the shop.*#WHITE#]],
	answers = {
		{"[fight]", action=function(npc, player)
			engine.Faction:setFactionReaction("kaltor-shop", player.faction, -100, true)
		end},
	}
}

return "welcome"
