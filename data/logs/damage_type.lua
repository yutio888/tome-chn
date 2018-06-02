logCHN:newLog{
	log = "%s shrugs off the critical damage!",
	fct = function(a)
		a = npcCHN:getName(a);
		return ("%s 摆脱了暴击伤害！"):format(a)
	end,
}

logCHN:newLog{
	log = "You end your target with a crushing blow!",
	fct = "你的毁灭一击终结了对手！",
}

logCHN:newLog{
	log = "#DARK_ORCHID#Your damage shield cannot be extended any farther and has exploded.",
	fct = "#DARK_ORCHID#你的伤害护盾不能再被延长，终于破碎了",
}

logCHN:newLog{
	log = "#Source# strikes #Target# in the darkness (%+d%%%%%%%% damage).",
	fct = function(a)
		return ("#Source# 在黑暗中打击了 #Target#  (%+d%%%%%%%%%%%%%%%% 伤害)!"):format(a)
	end,
}

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
	log = "%s resists the silence!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了沉默！"):format(a)
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
		return ("%s 抵抗了致盲！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the blinding flare!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了致盲！"):format(a)
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
	log = "#LIGHT_STEEL_BLUE#%s can't gain any more energy this turn!",
	fct = function(a)
		a = npcCHN:getName(a)
		return("#LIGHT_STELL_BLUE#%s 这回合不能获得更多时间！"):format(a)
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
	log = "%s resists the blind!",
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
	log = "%s resists the baneful energy!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了毒素！"):format(a)
	end,
}
logCHN:newLog{
	log = "%s resists the freezing!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了冰冻！"):format(a)
	end,
}
logCHN:newLog{
	log = "%s resists entanglement!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了纠缠！"):format(a)
	end,
}
logCHN:newLog{
	log = "%s has no mana to burn",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 没有可供燃烧的法力。"):format(a)
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
	log = "%s resists the shove!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了推拉！"):format(a)
	end,
}


logCHN:newLog{
	log = "asked the Eidolon to let %s die in peace",
	fct = function(...)
		return ("请求艾德隆让 %s 安息。"):format(...)
	end,
}

local normal_damtype = {
	["物理"] = "#WHITE#",
	["奥术"] = "#PURPLE#",
	["寒冷"] = "#1133F3#",
	["火焰"] = "#LIGHT_RED#",
	["闪电"] = "#ROYAL_BLUE#",
	["酸性"] = "#GREEN#",
	["自然"] = "#LIGHT_GREEN#",
	["枯萎"] = "#DARK_GREEN#",
	["光系"] = "#YELLOW#",
	["暗影"] = "#GREY#",
	["精神"] = "#YELLOW#",
	["时空"] = "#LIGHT_STELL_BLUE",
}


for i,k in pairs(normal_damtype) do
--print("DAMCHECK",i)
logCHN:newLog{
	log = "#Source##LIGHT_GREEN# HEALS#LAST# from "..k..i.."#LAST# damage!",
	fct = function() return "#Source# 因 "..k..i.."#LAST# 伤害受到了#LIGHT_GREEN# 治疗 #LAST#!" end,
}
logCHN:newLog{
	log = "#Source##LIGHT_GREEN# HEALS#LAST# from #aaaaaa#"..i.."#LAST# damage!",
	fct = function() return "#Source# 因 #aaaaaa#"..i.."#LAST# 伤害受到了#LIGHT_GREEN# 治疗 #LAST#!" end,
}
end
