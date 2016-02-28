

newChat{ id="welcome",
	text = [[@playername@ ，欢迎来到我的商店。]],
	answers = {
		{"让我看看货物吧。", action=function(npc, player)
			npc.store:loadup(game.level, game.zone)
			npc.store:interact(player)
		end},
		{"我是来寻求特殊训练的。", jump="training"},
		{"抱歉，我要走了。"},
	}
}

newChat{ id="training",
	text = [[我能教你物理学或者化学知识，学费100金一次。]],
	answers = {
		{"教我物理学知识吧。", action=function(npc, player)
			game.logPlayer(player, "工程师花费时间传授你物理学的基础知识。")
			player:incMoney(-100)
			player:learnTalentType("steamtech/physics", true)
			player:learnTalent(player.T_SMITH, true)
			player.changed = true
		end, cond=function(npc, player)
			if player.money < 100 then return end
			if player:knowTalentType("steamtech/physics") then return end
			return true
		end},
		{"教我化学知识吧。", action=function(npc, player)
			game.logPlayer(player, "工程师花费时间传授你化学的基础知识。")
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
