bigNewsCHN = {}
bigNewsCHN.trans = {}
function bigNewsCHN:newLog(l)
	bigNewsCHN.trans[l.log] = l
end
function bigNewsCHN:getLog(l, ...)
	if bigNewsCHN.trans[l] then
		if type(bigNewsCHN.trans[l].translation) == "function" then
			return bigNewsCHN.trans[l].translation(l, ...)
		elseif type(bigNewsCHN.trans[l].translation) == "string" then
			return bigNewsCHN.trans[l].translation, ...
		else 
			return l, ...
		end
	else
		return l, ...
	end
end
bigNewsCHN:newLog{
	log = "#GOLD#This portal looks like it reacts only to the Orb of Many Ways.",
	translation = "#GOLD#这个传送门似乎需要多元水晶球来激活。",
}
bigNewsCHN:newLog{
	log = "#DARK_GREEN#As Melinda is about to die a powerful wave of blight emanates from her!",
	translation = "#DARK_GREEN#危急之中，梅琳达身边突然爆发出一波枯萎能量。",
}
bigNewsCHN:newLog{
	log = "#DARK_GREEN#Melinda begins to glow with an eerie aura!",
	translation = "#DARK_GREEN#梅琳达身边环绕着一圈可怕的光环！",
}
bigNewsCHN:newLog{
	log = "#GOLD#Linaniil concentrates her formidable will to restore her body!",
	translation = "#GOLD#莱娜尼尔集中精神，利用她强大的意志复活了！",
}
bigNewsCHN:newLog{
	log = "#VIOLET#Limmir is attacked! Defend him!",
	translation = "#VIOLET#利米尔受到攻击！保护他！",
}
bigNewsCHN:newLog{
	log = "#STEEL_BLUE#Targeting %s",
	translation = "#STEEL_BLUE#请设定 %s 的目标。",
}
local get_quest_cname = function(name)
	if questCHN[name] then
		return questCHN[name].name
	else
		return name
	end
end
bigNewsCHN:newLog{
	log = "#LIGHT_GREEN#Accepted quest '%s'!",
	translation = function(log, name)
		return "#LIGHT_GREEN#接受任务 '%s'!", get_quest_cname(name)
	end,
}
bigNewsCHN:newLog{
	log = "#LIGHT_GREEN#Quest '%s' updated!",
	translation = function(log, name)
		return "#LIGHT_GREEN#任务 '%s' 更新了！", get_quest_cname(name)
	end,
}
bigNewsCHN:newLog{
	log = "#LIGHT_GREEN#Quest '%s' completed!",
	translation = function(log, name)
		return "#LIGHT_GREEN#任务 '%s' 完成了！", get_quest_cname(name)
	end,
}
bigNewsCHN:newLog{
	log = "#LIGHT_GREEN#Quest '%s' done!",
	translation = function(log, name)
		return "#LIGHT_GREEN#任务 '%s' 终结了！", get_quest_cname(name)
	end,
}
bigNewsCHN:newLog{
	log = "#LIGHT_RED#Quest '%s' failed!",
	translation = function(log, name)
		return "#LIGHT_RED#任务 '%s' 失败了！", get_quest_cname(name)
	end,
}
bigNewsCHN:newLog{
	log = "#CRIMSON#Interface locked, mouse enabled on the map",
	translation = "#CRIMSON#界面布局锁定，你可以用鼠标操作地图了。",
}
bigNewsCHN:newLog{
	log = "#CRIMSON#Interface unlocked, mouse disabled on the map",
	translation = "#CRIMSON#界面布局解锁，你暂时不能用鼠标操作地图。",
}
