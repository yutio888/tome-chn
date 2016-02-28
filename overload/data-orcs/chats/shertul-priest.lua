

local is_orc = function(npc, player) return player.type == "humanoid" and player.subtype == "orc" end
local is_yeti = function(npc, player) return player.type == "giant" and player.subtype == "yeti" end
local is_whitehoof = function(npc, player) return player.type == "undead" and player.subtype == "minotaur" end

local on_end = function(npc, player)
	if player:hasQuest("orcs+voyage") then
		player:setQuestStatus("orcs+voyage", engine.Quest.COMPLETED)
	else
		player:grantQuest("orcs+amakthel")
	end
end

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*站在你面前的是一个触手般的恐魔，然后你认出了他，
一个活着的 #{bold}#夏图尔#{normal}#!.*#WHITE#
	
	站在阿马克泰尔的大祭司面前的年轻生物啊，你是谁呢？你难道不清楚，站在你面前的，是伟大的创造者、太阳之父、神上之神、埃亚尔的主人的仆从？千年以来，我曾终结过许多像你这样的种族，我甚至扭曲过这世界上不朽神明的灵魂。小家伙，你认为自己是谁，竟敢妄言打败我？
]],
	answers = {
		{"我... 名为 "..player.name..", 是吞噬者加库尔的后裔。 加库尔教导我们挑战传奇，即使面前是绝望和死亡也绝不退缩。 现在，我站在这里面对着你，毫无恐惧，毫不犹豫, 因为加库尔之意志在我体内燃烧。以他之名，我一定会#{bold}#打败#{normal}# 你!", cond=is_orc, action=on_end},
		{"我... 名为 "..player.name..", 尽管我丢失了原本的身体，我的精神仍属于吞噬者加库尔。加库尔教导我们挑战传奇，即使面前是绝望和死亡也绝不退缩。  现在，我站在这里面对着你，毫无恐惧，毫不犹豫, 因为加库尔之意志在我体内燃烧。以他之名，我一定会#{bold}#打败#{normal}# 你! ", cond=is_yeti, action=on_end},
		{"我... 名为 "..player.name..",我超越死亡！加库尔教导兽人挑战传奇，即使面前是绝望和死亡也绝不退缩。我们从他们身上学会了这些！ 现在，我站在这里面对着你，毫无恐惧，毫不犹豫,因为亡灵冰冷的力量在我体内流淌。我一定会#{bold}#打败#{normal}# 你!", cond=is_whitehoof, action=on_end},
		{"我... 名为 "..player.name..".现在，我站在这里面对着你，毫无恐惧，毫不犹豫,因为坚定的意志在我体内燃烧。我一定会#{bold}#打败#{normal}# 你!", cond=function(npc, player) return not is_orc(npc, player) and not is_yeti(npc, player) and not is_whitehoof(npc, player) end, action=on_end},
	}
}

return "welcome"
