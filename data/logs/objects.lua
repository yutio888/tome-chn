logCHN:newLog{
	log = "#GOLD#A bolt of lightning fires from #Source#'s bow, striking #Target#!",
	fct = function()
		return "#GOLD# 一道闪电从 #Source# 的弓中射出，击中了 #Target# ！"
	end,
}

logCHN:newLog{
	log = "#Source# unleashes cosmic retribution at #Target#!",
	fct = function()
		return "#Source# 朝 #Target# 释放了宇宙的愤怒！"
	end,
}

logCHN:newLog{
	log = "#Source# strikes #Target# with %s %s, sending out an arc of lightning!",
	fct = function()
		return "#Source# 用 %s %s 击中了 #Target# ，射出一道闪电！"
	end,
}

logCHN:newLog{
	log = "Anmalice focuses its mind-piercing eye on #Target#!",
	fct = function()
		return "扭曲之刃·圣灵之眼将它穿透灵魂的目光集中在了 #Target# 上！"
	end,
}

logCHN:newLog{
	log = "#Source#'s three headed flail lashes at #Target#%s!",
	fct = function(a)
		if a:find(" and ") then
			a = " 和 " .. npcCHN:getName(a:gsub(" and ", ""))
		end
		return ("#Source# 的三头连枷扫过了 #Target#%s ！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Source#'s three headed flail lashes at #Target#!",
	fct = function()
		return "#Source# 的三头连枷扫过了 #Target# ！"
	end,
}

logCHN:newLog{
	log = "A wave of icy water sprays out from #Source# towards #Target#!",
	fct = function()
		return "一束冰冷的水流从 #Source# 处喷射出来冲向 #Target# ！"
	end,
}
logCHN:newLog{
	log = "#LIGHT_RED#You see no place to land near there.",
	fct = function()
		return "#LIGHT_RED#那边你看不见着陆的空间。"
	end,
}

logCHN:newLog{
	log = "#ORCHID#Black tendrils from #Source# grab #Target#!",
	fct = function()
		return "#ORCHID#黑暗触须从#Source#处伸出，抓住了 #Target#!"
	end,
}

logCHN:newLog{
	log = "#ORCHID#%s resists the tendrils' pull!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#ORCHID#%s 抵抗了触须的抓取!"):format(a)
	end,
}
logCHN:newLog{
	log = "#ORCHID#%s empowers %s %s",
	fct = function(a,b,c)
		a = npcCHN:getName(a)
		return ("#ORCHID#%s 强化了 %s %s"):format(a,b,c)
	end,
}
logCHN:newLog{
	log = "#YELLOW_GREEN#An ironic harmony surrounds Ureslak's remains as they reunite.",
	fct = function()
		return "#YELLOW_GREEN#乌尔斯拉克的遗物重聚时，和谐力量在此流转。"
	end,
}
logCHN:newLog{
	log = "#YELLOW_GREEN#Ureslak's remains seem more unsettled.",
	fct = function()
		return "#YELLOW_GREEN#乌尔斯拉克的遗物似乎更加不安定了。"
	end,
}

