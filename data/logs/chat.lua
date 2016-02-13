logCHN:newLog{
	log = "#LIGHT_BLUE#You select the timeline and re-arrange the universe to your liking!",
	fct = function()
		return "#LIGHT_BLUE#你选择了时间线，依照你喜欢的方式重组了这个世界！"
	end,
}

logCHN:newLog{
	log = "You cannot use your %s anymore; it is tainted by magic.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你不能再使用 %s ，它已被魔法所污染。"):format(name)
	end,
}

logCHN:newLog{
	log = "Aeryn points to the known locations on your map.",
	fct = function()
		return "艾伦在你的地图上指出了位置。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have learned the talent Relentless Pursuit.",
	fct = function()
		return "#VIOLET#你学会了无尽追踪技能。"
	end,
}

logCHN:newLog{
	log = "%s creates: %s",
	fct = function(a,b)
		a = npcCHN:getName(a)
		local name = objects:getObjectsChnName(b)
		return ("%s 创造了： %s"):format(a,name)
	end,
}

logCHN:newLog{
	log = "High Sun Paladin Aeryn appears next to you!",
	fct = function()
		return "高阶太阳骑士在你的身边出现了！"
	end,
}

logCHN:newLog{
	log = "Your golem equips: %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你的傀儡装备了：%s。"):format(name)
	end,
}

logCHN:newLog{
	log = "The smith spends some time with you, teaching you the basics of armour and weapon usage.",
	fct = function()
		return "铁匠花了一些时间，教会了你一些武器和护甲的基础知识。"
	end,
}

logCHN:newLog{
	log = "The smith spends some time with you, teaching you the basics of bows and slings.",
	fct = function()
		return "铁匠花了一些时间，教会了你一些弓和投石索的基础知识。"
	end,
}

logCHN:newLog{
	log = "The herald gives you %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("传令官交给了你 %s 。"):format(name)
	end,
}

logCHN:newLog{
	log = "The contact with the Wayist mind has improved your mental shields. (+15 mental save, +10%% confusion resistance)",
	fct = function()
		return "与维网的联系提高了你的精神护盾。 （+15精神豁免，+10%混乱抵抗）"
	end,
}

logCHN:newLog{
	log = "%s grabs her amulet and disappears in a whirl of arcane energies.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抓住了她的项链在一股奥术漩涡中消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "Melinda's father gives you: %s",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("梅琳达的父亲交给了你： %s"):format(name)
	end,
}

logCHN:newLog{
	log = "As you depart the assassin lord says: 'And do not forget, I own you now.'",
	fct = function()
		return "当你离开时你听到强盗头子说道：“别忘了，你是我的人了。”"
	end,
}

logCHN:newLog{
	log = "The temporal warden gives you: %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("时间守卫给了你： %s"):format(name)
	end,
}

logCHN:newLog{
	log = "He points out the location of the graveyard on your map.",
	fct = function()
		return "他在你的地图上指出墓地的位置。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#The merchant carefully hands you: %s",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("#LIGHT_BLUE#商人小心的交给了你： %s"):format(name)
	end,
}

logCHN:newLog{
	log = "#00FF00#You gain the fungus talents school.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("#00FF00#你获得了真菌系技能树。"):format(name)
	end,
}
logCHN:newLog{
	log = "#CRIMSON#Your timetravel has no effect on pre-determined outcomes such as this.",
	fct = function()
		return ("#00FF00#你的时间旅行对这种命中注定的结果没有影响。"):format(name)
	end,
}

