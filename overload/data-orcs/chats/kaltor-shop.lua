

local was_first_chat = not npc.not_first_chat

setDialogWidth(700)

local shop_answers = {
	{"终于来了一位有理性的巨人! 给我看看你的货。", action=function(npc, player)
		npc.store:loadup(game.level, game.zone)
		npc.store:interact(player, npc.name)
	end},
	{"死吧，巨人渣渣！为了克鲁克！为了加库尔！为了部落!", jump="attack"},
	{"现在不需要。"},
}

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*一名衣着讲究的巨人站在你面前，戴满昂贵的珠宝；从他松垮的项链扣上看，你猜测他是最近才拿到的。他微笑着从柜台往下看，注视着你。*#WHITE#
	
	哦，欢迎，@playername@! #LIGHT_GREEN#*他的声音大的让店里所有人都听见，同时他抬起头张望四周。*#WHITE# 是的，听见了么， @playername@!
就是那个在蒸汽商场猖獗无比的家伙，他到我这来买装备了!我认为不会有比这更好的宣传了! #LIGHT_GREEN#*他转过头看你，指出一个玻璃展台，那上面装满异种武器和护甲。*#WHITE#

好吧，我不会拒绝任何带着钱过来的人，同时你也已经让我富裕不少了。
我还能给你打个折。 #LIGHT_GREEN#*他靠得过近，让你感觉不太舒服。他直视着你的眼睛。* #WHITE#或者，你也可以试试你在蒸汽商店里干的事情...
 #LIGHT_GREEN#*他指向周围和房间里那些装备良好的警卫。*#WHITE# 
 我相信我的#{italic}#紧急安全设备#{normal}#一定#{italic}#爱死了#{normal}#每一个尝试新玩具的机会。]],
	answers = shop_answers,
}

newChat{ id="back",
	text = [[欢迎回来, @playername@! 来看看这个，顾客们?这位可怕而野蛮的战斗大师也对我的产品印象深刻，现在他又回来买东西了!
#LIGHT_GREEN#*他指向墙上贴着的新海报,上面是你的脸和一行大字 #{bold}#"卡托尔：破坏者的选择！"#{normal}#*#WHITE#

那么，你要做什么呢?]],
	answers = shop_answers,
}

newChat{ id="gem",
	text = [[#LIGHT_GREEN#*卡托尔忙着打包货物；他将箱子递给一个工人带到后门，然后转过头和你说话。*#WHITE#
	快点吧, @playername@. 不是我粗鲁，但现在有一艘我的飞船在外面，我更想站在上面鸟瞰你要做的事情，而不是坐在椅子上。]],
	answers = shop_answers,
}

newChat{ id="attack",
	text = [[#LIGHT_GREEN#*他脸上露出失望的深色，按下外套上的按钮。它发出嘶嘶声，你听见引擎的轰鸣。*#WHITE#
	真遗憾。警卫？谁杀了他，就有一万金的赏钱。当然，记在商店账上。]],
	answers = {
		{"死吧！", action=function(npc, player)
			engine.Faction:setFactionReaction("kaltor-shop", player.faction, -100, true)
		end},
	}
}



npc.not_first_chat = true
if player:isQuestStatus("orcs+gem", engine.Quest.DONE) then return "gem"
elseif not was_first_chat then return "back"
else return "welcome"
end
