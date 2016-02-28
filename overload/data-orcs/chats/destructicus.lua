

setDialogWidth(800)

local npc_destructicus = npc
local npc_imp = mod.class.NPC.new{name="Fire Imp", image="npc/demon_minor_fire_imp.png"}
local npc_giant = mod.class.NPC.new{name="Steam Giant Airship", image="npc/giant_steam_steam_giant_gunner.png", resolvers.nice_tile{tall=1}}
npc_giant:resolve()
npc_giant:resolve(nil, true)

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*#{bold}#裂天者 毁灭号#{normal}# 站在你面前，让你痛苦地承认，卡托尔的广告并不全是垃圾。这是你见过的最无端致命的设备。阳光照耀在它的沃瑞坦躯壳上，在它边缘上镶嵌的强大而不稳定的符文面前黯然失色;它的表面有着金属历经数个小时精心打磨而成的华丽沟槽，在发射管上搭载的刺刀能轻盈地上下游走。控制组件上环绕着一层密封的防火隔间，操作室内建的自动饮水机还能提供矮人的佳酿。这简直就是美的化身。*#WHITE#]],
	answers = {
		{"[继续]", jump="welcome2"},
	}
}

newChat{ id="welcome2",
	text = [[#LIGHT_GREEN#*你进入了操作室，坐好，插入钥匙。#{bold}#裂天者 毁灭号#{normal}# 启动了它的生命,它的基座开始运转。一块奇怪的珍珠板从你前方滑过，针伸了出来，被电磁力量控制，显示出飞船的轮廓（以及一个小黑点）与以下短语：#{italic}#"发现空中目标-数目：2."#{normal}#*#WHITE#]],
	answers = {
		{"[继续]", jump="next"},
	}
}

newChat{ id="next",
	text = [[#LIGHT_GREEN#*#{italic}#"解除锁定中...  解除成功."#{normal}#
 
珍珠面板突然充满色彩，显示飞船的巨大内部结构。蒸汽巨人们拥挤而哭泣，带着少量东西逃走。一名守卫用手抱头，坐在储藏室前。视角切换到船舱，你看见一些成员匆忙走过船长室和引擎室，偶尔忧虑地瞥向窗外——看向你。
飞船似乎开始计算气之部落还剩下些什么。只要按下一个按钮，你将能永久摧毁蒸汽巨人这个种族。

你按下按钮 #{italic}#"选择下个目标"#{normal}#，面板显示出一个迷茫而混乱的火焰恶魔，在空中无害地飞舞。向他开火没什么意义，只是以最无害的方式炫耀毁灭号的力量。*#WHITE#]],
	answers = {
		{"[击落飞船]", jump="airship", switch_npc=npc_giant},
		{"[击落恶魔]", jump="imp", switch_npc=npc_imp},
	}
}

newChat{ id="airship",
	text = [[#LIGHT_GREEN#*你#{italic}#确认#{normal}#要#{italic}#消灭蒸汽巨人#{normal}#么?*#WHITE#]],
	answers = {
		{"[击落飞船]", jump="shoot_airship"},
		{"[返回]", jump="next", switch_npc=npc_destructicus},
	}
}

newChat{ id="imp",
	text = [[#LIGHT_GREEN#*你#{italic}#确认#{normal}#要#{italic}#浪费子弹#{normal}#么?*#WHITE#]],
	answers = {
		{"[击落恶魔]", jump="shoot_imp"},
		{"[返回]", jump="next", switch_npc=npc_destructicus},
	}
}

newChat{ id="shoot_airship",
	text = [[#LIGHT_GREEN#*让蒸汽巨人们逃离太过危险 - 你不能允许他们这样简单的离开，然后将来某日再实现其图谋, 消灭你的部落。你按下#{italic}#"上一名目标"#{normal}# 按钮，朝飞船开火。一阵巨大的轰鸣声和一道强烈的火光闪过，你从窗户里看见导弹朝目标飞去，飞向你视线远处，拥挤的飞船里惊恐的乘客那边。

导弹到达了目的地，巨大的爆炸堵塞了你透过窗户的视线，令操作舱的光线变得黑暗低沉。

蒸汽巨人消失了。

第二发导弹带着火光坠落大海，这场持续的烟火盛宴成为大陆上所有兽人，甚至所有能看到这一盛景的生物的信号：
这就是所有试图消灭兽人的种族的命运。千年的压制、欺凌和屠杀被终结了：你的人民再也不会沦落如斯。

无法摆脱的念头自你脑后升腾，你现在明白了太阳骑士的感受，明白了图库纳国王的感受，明白了半身人的感受，明白了所有对曾兽人施以暴行的人的感受。
它能继续哀诉一切————但你的人民终于安全了。*#WHITE#]],
	answers = {
		{"[leave]", action=function(npc, player)
			npc_destructicus.add_displays[3] = nil
			npc_destructicus:removeAllMOs()
			npc_destructicus:altered()
			game.level.map:updateMap(dx, dy)
			npc_destructicus.block_move = true
			world:gainAchievement("ORCS_DESTRUCTICUS_AIRSHIP", player)
		end},
	}
}

newChat{ id="shoot_imp",
	text = [[#LIGHT_GREEN#*不。。。你不会让自己踏入那无尽的深渊，踏入那图库纳国王、太阳骑士和所有其他人都曾陷入的深渊中。
	
	这些难民不再是威胁，很长时间内都不可能成为威胁。。。但最好能让他们充分意识到你的力量，你本能轻易带来的毁灭命运，向他们展示这一切，让他们永远铭记：他们的生死取决于你的仁慈。
	
	你瞄准了火焰恶魔，令武器开火。巨大的轰鸣声和火光闪过，#{bold}#裂天者 毁灭号#{normal}#朝那只虚弱的恶魔冲过去。它惊恐无比，试图躲避，而#{bold}#裂天者 毁灭号#{normal}#相对修正了行进路线，直到它彻底放弃，沮丧地颤抖。在导弹的轰鸣声中，你不能听见飞船里的声音，不过你能肯定恶魔的嘴型在说'这真滑稽'。
	
	导弹到达了目的地，巨大的爆炸堵塞了你透过窗户的视线。碎片无害地坠落在山顶，整个大陆都听见了巨大的爆鸣声。
 
	痛饮刚分下来的美酒，你将已经空仓的#{bold}#裂天者 毁灭号#{normal}#指向飞船，不出所料看见巨人们欢呼拥抱，在安心和喜悦中痛苦流涕。少数大声质疑你为什么这么做，而大部分人明白这是仁慈的表示。

 	第二发导弹带着火光坠落大海，这场持续的烟火盛宴成为大陆上所有蒸汽巨人，所有兽人，甚至所有能看到这一盛景的生物的庆典：
 	战争结束了。
 	千年以来，埃亚尔大陆，以及拥有它的兽人们，第一次明白了和平的意义。*#WHITE#]],
	answers = {
		{"[离开]", action=function(npc, player)
			npc_destructicus.add_displays[3] = nil
			npc_destructicus:removeAllMOs()
			npc_destructicus:altered()
			game.level.map:updateMap(dx, dy)
			npc_destructicus.block_move = true
			world:gainAchievement("ORCS_DESTRUCTICUS_IMP", player)
		end},
	}
}

return "welcome"
