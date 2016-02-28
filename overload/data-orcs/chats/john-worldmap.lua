

local jump = function(npc, player)
	npc:disappear()
	game:changeLevel(1, "orcs+cave-hatred")
end

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*当你靠近时，你认出了那是前哨站首领约翰。但他身边环绕着可怕的黑暗，你能感受到他的仇恨令空气结晶。*#WHITE#
@playername@. 你这个残忍的畜生! #{bold}#你杀了她! 你这条残忍的狗!#{normal}#
你 #{italic}#竟敢#{normal}# 带着她的戒指作为战利品!我能感觉到它在你身上。拿出来，然后死吧！！]],
	answers = {
		{"哦~你喜欢那个女圣骑士？我爱死杀她的感觉了!", action=jump},
		{"她令我别无选择; 我必须保护 #{bold}#我的#{normal}# 族民.", action=jump},
		{"无所谓.", action=jump},
		{"什么?", action=jump},
	}
}

return "welcome"
