

newChat{ id="welcome",
	text = [[Welcome @playername@ to my shop.]],
	answers = {
		{"Let me see your wares.", action=function(npc, player)
			npc.store:loadup(game.level, game.zone)
			npc.store:interact(player)
		end},
		{"I am looking for special training.", jump="training"},
		{"Sorry, I have to go!"},
	}
}

newChat{ id="training",
	text = [[I can indeed offer some training (talent category Steamtech/Physics and Steamtech/Chemistry) for a fee of 100 gold pieces each.]],
	answers = {
		{"Please train me in physics.", action=function(npc, player)
			game.logPlayer(player, "The tinker spends some time with you, teaching you the basics of smithing.")
			player:incMoney(-100)
			player:learnTalentType("steamtech/physics", true)
			player:learnTalent(player.T_SMITH, true)
			player.changed = true
		end, cond=function(npc, player)
			if player.money < 100 then return end
			if player:knowTalentType("steamtech/physics") then return end
			return true
		end},
		{"Please train me in chemistry.", action=function(npc, player)
			game.logPlayer(player, "The tinker spends some time with you, teaching you the basics of therapeutics.")
			player:incMoney(-100)
			player:learnTalentType("steamtech/chemistry", true)
			player:learnTalent(player.T_THERAPEUTICS, true)
			player.changed = true
		end, cond=function(npc, player)
			if player.money < 100 then return end
			if player:knowTalentType("steamtech/chemistry") then return end
			return true
		end},
		{"No thanks."},
	}
}

return "welcome"
