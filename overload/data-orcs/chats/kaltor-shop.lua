

local was_first_chat = not npc.not_first_chat

setDialogWidth(700)

local shop_answers = {
	{"Finally a practical giant! Show me your wares.", action=function(npc, player)
		npc.store:loadup(game.level, game.zone)
		npc.store:interact(player, npc.name)
	end},
	{"Die giant scum! For Kruk! For Garkul! For the Pride!", jump="attack"},
	{"No need for shopping now."},
}

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*A well-dressed giant stands in front of you, covered in expensive jewelry; judging from the poorly-fastened clasp on his necklace, you can assume he acquired it all fairly recently.  He grins as he leans down over the counter to get a good view of you.*#WHITE#
Ah, welcome, @playername@! #LIGHT_GREEN#*he yells in a voice loud enough to catch the attention of all in the shop, as he lifts his head to look around.*#WHITE# Yes, you heard me right, @playername@! The very same one who's been running rampant through the Vaporous Emporium is coming to ME for armaments! I don't think I could've asked for a stronger endorsement! #LIGHT_GREEN#*He looks back down to you, leaning over the counter to point out a glass display case loaded with exotic weaponry and armor.*#WHITE#
Well, I'm not one to turn down anyone with gold, and seeing as you've already made me rich, I'll even give you a discount, down to my pre-attack prices. #LIGHT_GREEN#*He leans in uncomfortably close, staring you in the eyes.* #WHITE#Or, if you came to do here what you did in the Emporium... #LIGHT_GREEN#*He directs his glare toward the multiple well-armed guards staring at you and standing still on the sides of the room.*#WHITE# I'm sure my #{italic}#emergency safety measures#{normal}# would just #{italic}#love#{normal}# an opportunity to try out their shiny new toys.]],
	answers = shop_answers,
}

newChat{ id="back",
	text = [[Welcome back, @playername@!  You see this, customers?  This fearsome, savage master of battle was so impressed by my products that he came back for more!
#LIGHT_GREEN#*He points to a new poster on the wall next to him, showing your face and the caption #{bold}#"KALTOR: THE CHOICE OF DESTROYERS!"#{normal}#*#WHITE#

So, what'll it be?]],
	answers = shop_answers,
}

newChat{ id="gem",
	text = [[#LIGHT_GREEN#*Kaltor is busy packing some of his goods away in crates; he hands one to a worker, carrying it out the back door, before turning to you.*#WHITE#
	Make it quick, @playername@. Not to be rude, but there's a private airship out there with my name on it, and I'd rather have a bird's-eye view of what you're about to do than a front-row seat.]],
	answers = shop_answers,
}

newChat{ id="attack",
	text = [[#LIGHT_GREEN#*He frowns in mock disappointment, as he presses a button on his stylish coat; it hisses, and you hear motors whirring*#WHITE#
Oh, what a pity.  Guards?  Ten thousand gold to whoever gets the killing blow.  Store credit, of course.]],
	answers = {
		{"DEATH!", action=function(npc, player)
			engine.Faction:setFactionReaction("kaltor-shop", player.faction, -100, true)
		end},
	}
}



npc.not_first_chat = true
if player:isQuestStatus("orcs+gem", engine.Quest.DONE) then return "gem"
elseif not was_first_chat then return "back"
else return "welcome"
end
