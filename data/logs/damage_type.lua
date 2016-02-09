logCHN:newLog{
	log = "%s shrugs off the critical damage!",
	fct = function(a)
		a = npcCHN:getName(a);
		return ("%s 摆脱了暴击伤害！"):format(a)
	end,
}
--[[
logCHN:newLog{
	log = "#Source# strikes #Target# in the darkness (%+d%%%%%%%% damage).",
	fct = function(a)
		return ("#Source# 在黑暗中打击了 #Target#  (%+d%%%%%%%% 伤害)!"):format(a)
	end,
}
]]
logCHN:newLog{
	log = "#CRIMSON##Source# damages %s through Martyrdom!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#CRIMSON##Source# 通过殉难伤害了 %s !"):format(a)
	end,
}

logCHN:newLog{
	log = "#CRIMSON##Source# reflects damage back to #Target#!",
	fct = function()
		return ("#CRIMSON##Source# 将伤害反射回 #Target#!")
	end,
}

logCHN:newLog{
	log = "%s forces the iceblock to shatter.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 将冰块打破。"):format(a)
	end,
}

logCHN:newLog{
	log = "The diseases of %s spread!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 疫病效果受到传播！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the mind attack!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了精神攻击！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the stun!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了震慑！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了效果！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the blinding light!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了致盲伤害！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s avoids the blinding ink!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s躲开了致盲墨汁的攻击！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the darkness!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了黑暗！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the searing flame!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了灼热火焰！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s is knocked back!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被击退。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the wave!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了冲击！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the bloody wave!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了血浪！"):format(a)
	end,
}
logCHN:newLog{
	log = "%s resists the punch!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了击退！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the frightening sight!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了恐惧。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s turns into %s.",
	fct = function(a,b)
		if gridCHN[a] then
			a = gridCHN[a]
		elseif gridCHN[string:uncapitalize(a)] then
			a = gridCHN[string:uncapitalize(a)]
		end
		if gridCHN[b] then
			b = gridCHN[b]
		end
		return ("%s 变成了 %s。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s resists the time prison.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了时间牢笼。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the sandstorm!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了沙暴！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Source# drains experience from #Target#!",
	fct = function()
		return ("#Source# 从 #Target# 吸取了经验值！")
	end,
}

logCHN:newLog{
	log = "#Source# drains life from #Target#!",
	fct = function()
		return ("#Source# 从 #Target# 吸取了生命！")
	end,
}

logCHN:newLog{
	log = "%s resists the knockback!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了击退！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s has not been stopped!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 无法被中断！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the stun!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了震慑！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the blindness!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了致盲！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the pin!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了定身！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the confusion!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了混乱！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Source# consumes %d life from #Target#!",
	fct = function(a)
		return ("#Source# 从 #Target#身上吸取了生命!"):format(a)
	end,
}

logCHN:newLog{
	log = "%s is unaffected.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不受影响。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the bane!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了毒药！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the forge bellow!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了熔炉击退！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the dream forge!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了梦境熔炉！"):format(a)
	end,
}

logCHN:newLog{
	log = "asked the Eidolon to let %s die in peace",
	fct = function(...)
		return ("请求艾德隆让 %s 安息。"):format(...)
	end,
}



