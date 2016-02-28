

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*当你打开商店大门，你被一群蒸汽巨人警卫包围，他们盯着你看，手中紧握蒸汽枪，准备就绪，但并没有瞄准你。*#WHITE#
	
	别乱动， @playername@。卡托尔的指令让我们将你视为顾客。
做蠢事的话，你将被他最新的枪支毁灭。明白了么?]],
	answers = {
		{"我有钱，你们有装备。没什么更复杂的东西。", jump="ok"},
		{"这些枪看起来挺有趣的。你们以为有了这些装备，我就不能打得你们头破血流了么？", jump="fight"},
	}
}

newChat{ id="ok",
	text = [[#LIGHT_GREEN#*她微微一笑，轻松却似乎有些失望。*#WHITE#
那再好不过。进来吧 - 别吓到其他顾客。]],
	answers = {
		{"[进入]"},
	}
}

newChat{ id="fight",
	text = [[祝你好运，野蛮人。
#LIGHT_GREEN#*她假笑着，拉下她身边墙上的绳子，她的同伴从角落里出来。一阵铃响，你听见商店里的骚动。*#WHITE#]],
	answers = {
		{"[战斗]", action=function(npc, player)
			engine.Faction:setFactionReaction("kaltor-shop", player.faction, -100, true)
		end},
	}
}

return "welcome"
