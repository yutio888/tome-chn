logCHN:newLog{
	log = "#ROYAL_BLUE#The golem decides to change it's name to #{bold}#%s#{normal}#.",
	fct = function(a)
	    a = npcCHN:getName(a)
	    return("#ROYAL_BLUE#傀儡决定将名字更改为 #{bold}#%s#{normal}#."):format(a)
	    end,
}

logCHN:newLog{
	log = "#CADET_BLUE#%s already mastered.",
	fct = function(a)
	    return("#CADET_BLUE#%s 已经被强化过了"):format(a)
	    end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE# You enhance your preparation of %s.",
	fct = function(a)
	    return("#LIGHT_BLUE# 你强化了你准备的%s."):format(a)
		end,
}

logCHN:newLog{
	log = "#CADET_BLUE#%s already equipped at level %d.",
	fct = function(a,b)
	    return("#CADET_BLUE#%s 已经被装备了，等级 %d."):format(a,b)
		end,
}

logCHN:newLog{
	log = "#CADET_BLUE#Equipping %s with %s (level %d).",
	fct = function(a,b,c)
	    return("#CADET_BLUE# 装备 %s，用 %s (等级 %d)."):format(a,b,c)
		end,
}

logCHN:newLog{
	log = "#LIGHT_GREEN#You and the Lord discuss your new relationship at some length, including the merits of assassination by proxy and some additional trapping techniques.",
	fct = "#LIGHT_GREEN# 你和盗贼头子讨论了你们的新关系，同时还讨论了部分暗杀和陷阱技巧。",
}

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
		return "艾琳在你的地图上指出了位置。"
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
		return "高阶太阳骑士艾琳在你的身边出现了！"
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
	log = "Aeryn gives you: %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("艾琳交给了你 %s 。"):format(name)
	end,
}


logCHN:newLog{
	log = "The contact with the Wayist mind has improved your mental shields. (+15 mental save, +10%% confusion resistance)",
	fct = function()
		return "与夺心魔的接触提高了你的精神防御。 （+15精神豁免，+10%混乱抵抗）"
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

logCHN:newLog{
	log = "The staff carver spends some time with you, teaching you the basics of staff combat.",
	fct = "法杖商人花了一些时间，教授你法杖格斗的基础知识。",
}

logCHN:newLog{
	log = "He is surprised at how quickly you are able to follow his tutelage.",
	fct = "他对你学习速度之快感到惊讶。",
}

logCHN:newLog{
	log = "The staff carver spends a substantial amount of time teaching you all of the techniques of staff combat.",
	fct = "法杖商人花了大量时间，教授你法杖格斗的全部知识",
}

logCHN:newLog{
	log = "The staff carver spends a great deal of time going over the finer details of staff combat with you%s.",
	fct = function(a)
	    a = a:gsub("including some esoteric techniques","以及一些高深的技巧")
	    return ("法杖商人花了大量时间，教授你法杖格斗的最终知识%s。"):format(a)
	    end,
}

logCHN:newLog{
	log = "He is impressed with your mastery and shows you a few extra techniques.%s",
	fct = function()
	    return ("他对你已经掌握的知识印象深刻，并展示给你一些额外技巧。")
	    end,
}

logCHN:newLog{
	log = "The shopkeeper spends some time with you, teaching you the basics of channeling energy through mindstars.",
	fct = "商人花了一些时间，教授你使用灵晶的基础技巧",
}

logCHN:newLog{
	log = "He is impressed with your affinity for natural forces.",
	fct = "他对你同自然力量的亲和度感到惊讶",
}

logCHN:newLog{
	log = "The shopkeeper spends a great deal of time going over the finer details of channeling energy through mindstars with you.",
	fct = function()
	    return ("商人花了大量时间，教授你使用灵晶的全部技巧。"):format()
	    end,
}


logCHN:newLog{
	log = "The shopkeeper spends a great deal of time going over the finer details of channeling energy through mindstars with you%s.",
	fct = function(a)
	    a = a:gsub(" and teaches you enhanced mental discipline needed to maintain powerful energy fields","教授你一些进阶技术来维持强大的能量领域")
	    return ("商人花了大量时间，教授你使用灵晶的全部技巧%s。"):format(a)
	    end,
}

logCHN:newLog{
	log = "He is impressed with your mastery and shows you a few tricks to handle stronger energy flows.",
	fct = "他对你已经掌握的知识印象深刻，并展示给你一些对抗强敌的技巧",
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You cannot prepare this trap: %s.",
	fct = function(a)
	    return ("#LIGHT_BLUE#你不能准备这个陷阱: %s."):format(a)
	end,
}

logCHN:newLog{
	log = "#PURPLE#A paradox has already destroyed other timelines!",
	fct = "#PURPLE#一个时空紊乱摧毁了其他时间线!",
}

	