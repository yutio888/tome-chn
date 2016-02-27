

-----------------------------------------------------------------------
-- For non whitehooves
-----------------------------------------------------------------------
newChat{ id="nw-welcome",
	text = [[#LIGHT_GREEN#*Before you stands an impressive undead minotaur.*#WHITE#
I would like to talk to you.]],
	answers = {
		{"Yes?", jump="nw-explain", cond=function(npc, player) return not player:hasQuest("orcs+krimbul") end},
		{"Your clan is free Metash, the tyrant is no more.", jump="nw-thanks", cond=function(npc, player) return player:hasQuest("orcs+krimbul") and player:isQuestStatus("orcs+krimbul", engine.Quest.DONE) end},
		{"Not now."},
	}
}

newChat{ id="nw-explain",
	text = [[Soft-foot of the Kruk, I come to give you a warning, an apology, and a plea for help.  An incredible magical force has awakened within one of our elders, Nektosh the One-Horned, and he has gone mad with its power.  Those who stood up against him were reduced to less than ashes by a beam from his horn, a beam that tunneled far up through the rock above him until we could see the sky.  He has convinced some of us that he can use this terrible force to conquer Eyal and terrified others into going along with him; he has announced that his first step will be to lead his followers in an attack on Kruk Pride.]],
	answers = {
		{"[listen]", jump="nw-explain2"},
	}
}

newChat{ id="nw-explain2",
	text = [[The rest of us have fled, hiding in caverns across the peninsula...  I cannot in good conscience ask you to face certain death before his magic for our sakes, but striking first may be the only way to save your people.  He appears to be stalling the invasion, buying you some time, but if you cannot catch him off-guard before he finally commits to it...  I've seen his power cut through a mountain like it was a leaf, soft-foot.  There can be no victory against that kind of magic.  Run, hide, and hope he falls victim to an accident or loses the remaining fragments of his sanity that keep him capable of casting spells.]],
	answers = {
		{"I will check it out", action=function(npc, player) player:grantQuest("orcs+krimbul") end},
	}
}

newChat{ id="nw-thanks",
	text = [[We of the Krimbul Clan have faced our near-certain deaths all too many times, even after our hearts stopped beating; this is the first time we have been shown the kindness of utter salvation by an outsider.  Those who were not enthralled by Nektosh and are not delusionally faithful to his "cause" will reclaim the Mana Caves in time; until then, we will join your Pride in your revolution.  You have liberated us, and we will not rest until you are freed of your oppressors as well.]],
	answers = {
		{"Thanks.",},
	}
}

-----------------------------------------------------------------------
-- For whitehooves
-----------------------------------------------------------------------
newChat{ id="w-welcome",
	text = [[Hail, @playername@!]],
	answers = {
		{"Yes?", jump="w-explain", cond=function(npc, player) return not player:hasQuest("orcs+krimbul") end},
		{"Our is free Metash, the tyrant is no more.", jump="w-thanks", cond=function(npc, player) return player:hasQuest("orcs+krimbul") and player:isQuestStatus("orcs+krimbul", engine.Quest.DONE) end},
		{"Not now."},
	}
}

newChat{ id="w-explain",
	text = [[I came here to warn the Kruk Pride of the threat Nektosh poses and ask for their help, but they have some more immediate threats to deal with...  We should help them repel these Steam Giants.  They are the only people who have ever treated us with respect and dignity; if they are crushed by the Atmos Tribe or the Allied Kingdoms, we will surely be next.  Their success is our survival.

Unfortunately, they cannot afford to spare the warriors to retake the Mana Caves from that tyrant, and I need to stay here to help them defend their land.  The task of freeing our clan is in your hands, when you feel ready for it.]],
	answers = {
		{"[listen]", jump="w-explain2"},
	}
}

newChat{ id="w-explain2",
	text = [[Nektosh claims he is the invincible, omnipotent descendant of a unicorn, but I don't believe that bull for a second.  While the great magical power that suddenly awakened within him is as fearsome as it is insanity-inducing,  he has yet to use it to make a shield or teleport himself, and even with his all-powerful beam, his aim isn't always perfect...  I think he has a weakness he's trying to hide.  Fight with courage, fellow Whitehoof, and the Krimbul Clan may be free once more!]],
	answers = {
		{"I will!", action=function(npc, player) player:grantQuest("orcs+krimbul") end},
	}
}

newChat{ id="w-thanks",
	text = [[He...  he found a wand?  And he realized it was running dry, but only after taking over the tribe?  I pity him, but I cannot forgive him for being willing to sacrifice so many Whitehooves and Orcs to escape the consequences of his brief lapse into madness...  still, as a personal request I ask that you not tell others of his last thoughts.  The Nektosh we once knew saved our tribe from the corrupted magic deep under Eyal; he deserves to, at worst, be remembered as one who tragically succumbed to its influence.

Ultimately, though, the choice is yours; it is more important that he is no longer a threat.  There are some who may still cling to the false hope he gave them, but we will retake the Mana Caves from them in time.  We owe you a great debt, and now that we have no more pressing concerns, we can aid Kruk Pride in their rebellion.  Good travels, @playername@.]],
	answers = {
		{"To you too, Metash.",},
	}
}



if player.descriptor and player.descriptor.subrace == "Whitehoof" then
	return "w-welcome"
else
	return "nw-welcome"
end
