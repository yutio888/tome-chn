logCHN:newLog{
	log = "An entity appears through the portal!",
	fct = function()
		return "有东西穿过了传送门！"
	end,
}

logCHN:newLog{
	log = "Limmir summons a blast of holy light!",
	fct = function()
		return "利米尔召唤出一道圣光！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#%s rises from the dead!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_RED#%s 从尸体中站了起来！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s says: '%s'",
	fct = function(a,b)
		a = npcCHN:getName(a)
		if b == "Hey you. Come here." then b = "喂！说你呢，到这边来。" end
		return ("%s 说道：“ %s ”"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s%s hits %s for %s damage (total %0.2f).",
	fct = function(e,a,b,c,d)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s%s 攻击 %s 造成 %s 伤害（总伤害 %0.2f ）。"):format(e,a,b,c,d)
	end,
}

logCHN:newLog{
	log = "%s%s hits %s for %s damage.",
	fct = function(d,a,b,c)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s%s 攻击 %s 造成 %s 伤害。"):format( d, a, b, c)
	end,
}

logCHN:newLog{
	log = "There is an item here: %s",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("发现物品：%s。"):format(name)
	end,
}

logCHN:newLog{
	log = "%s is too afraid to attack.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 由于恐惧而无法攻击。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s is too terrified to attack.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 由于恐惧而无法攻击。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# repels an attack from #Source#.",
	fct = function()
		return ("#Target# 击退了#Source#的进攻.")
	end,
}
logCHN:newLog{
	log = "#{bold}##Source# performs a melee critical strike against #Target#!#{normal}#",
	fct = function()
		return ("#{bold}##Source#向#Target#发起一次近战暴击!#{normal}#")
	end,
}

logCHN:newLog{
	log = "#Target# evades #Source#.",
	fct = function()
		return "#Target# 闪避了 #Source# 。"
	end,
}


logCHN:newLog{
	log = "#Source# misses #Target#.",
	fct = function()
		return "#Source# 未命中 #Target#。"
	end,
}


logCHN:newLog{
	log = "%s ripostes!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 进行还击！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s counters the attack!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s进行了反攻！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s focuses and gains an extra blow!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的专注获得额外一击！"):format(a)
	end,
}

logCHN:newLog{
	log = "#{bold}#%s's spell attains critical power!#{normal}#",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#{bold}#%s的法术造成了致命一击！#{normal}#"):format(a)
	end,
}

logCHN:newLog{
	log = "#{bold}#%s's mind surges with critical power!#{normal}#",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#{bold}#%s的精神攻击造成了致命一击！#{normal}#"):format(a)
	end,
}

logCHN:newLog{
	log = "#Source#'s grapple fails because #Target# is too big",
	fct = function()
		return ("#Source#的抓取失败了，因为#Target#体型过大!")
	end,
}

logCHN:newLog{
	log = "%s resists the grapple!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了抓取！"):format(a)
	end,
}


logCHN:newLog{
	log = "%s's darkness can no longer hold back the light!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的暗影无法再抵御光明！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s temporarily fights the paralyzation.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 暂时在瘫痪中挣扎。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s heal is doubled!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 造成双倍治疗！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s steals %s heal!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 盗取了 %s 治疗！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s unleashes the stored damage in retribution!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 发动累积的伤害进行报复性攻击！"):format(a)
	end,
}

logCHN:newLog{
	log = "Some of the damage has been displaced onto %s!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("部分伤害被转移至 %s ！"):format(a)
	end,
}

logCHN:newLog{
	log = "The displacement shield teleports the damage to %s!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("护盾将伤害转移至 %s ！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s shatters into pieces!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被打成碎片！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s splits in two!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 分裂成了两个！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s's shield of light spell has crumbled under the attack!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的圣光沁盾在攻击下被破坏！"):format(a)
	end,
}

logCHN:newLog{
	log = "#YELLOW#%s has been healed by a blast of positive energy!#LAST#",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#YELLOW#%s 被一股正能量治疗！#LAST#"):format(a)
	end,
}

logCHN:newLog{
	log = "%s fades for a moment and then reforms whole again!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 消失了一阵之后又完好无损地出现了！"):format(a)
	end,
}

logCHN:newLog{
	log = "#CRIMSON##Source# leeches life from #Target#!",
	fct = function()
		return ("#LIGHT_RED# #Source# 从#Target#身上吸取生命！")
	end,
}

logCHN:newLog{
	log = "#CRIMSON##Source# leeches energies from #Target#!",
	fct = function()
		return ("#LIGHT_RED# #Source# 从#Target#身上吸取能量！")
	end,
}



logCHN:newLog{
	log = "%s is too afraid to use %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 由于恐惧无法使用 %s 。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s is silenced and cannot use %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 被沉默而无法使用 %s 。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "The spell fizzles.",
	fct = function()
		return "法术失败了。"
	end,
}

logCHN:newLog{
	log = "%s is too disconnected from Nature to use %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 扰乱了自然平衡而无法使用 %s 。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s is unable to use this kind of inscription.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 无法使用这类纹身。"):format(a)
	end,
}

logCHN:newLog{
	log = "You are too heavily armoured to use this talent.",
	fct = function()
		return "你的护甲太重了无法使用这个技能。"
	end,
}

logCHN:newLog{
	log = "You can't use this talent while holding a weapon or shield.",
	fct = function()
		return "你无法在手持武器或者护盾的情况下使用这个技能。"
	end,
}

logCHN:newLog{
	log = "%s is confused and fails to use %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 陷入混乱使用 %s 时失败。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s fails to use %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 使用 %s 时失败。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s is too terrified to use %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 由于恐惧而无法使用 %s 。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s activates %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 激活了 %s 。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s deactivates %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 停用了 %s 。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s casts %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 施展了 %s 。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s uses %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 使用了 %s 。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s shoots!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 射击!"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s suffocates to death!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 窒息而死亡！"):format(a)
	end,
}
logCHN:newLog{
	log = "#LIGHT_RED#%s starts suffocating to death!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_RED#%s 窒息了！"):format(a)
	end,
}


logCHN:newLog{
	log = "#ORANGE#%s shrugs off the effect '%s'!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("#ORANGE#%s 豁免了“ %s ”效果！"):format(a,effName[b] or b)
	end,
}

logCHN:newLog{
	log = "%s reflects the spell!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 反射了法术！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s ignores the spell!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 无视了法术！"):format(a)
	end,
}

logCHN:newLog{
	log = "Dark energies course upwards through the lava.",
	fct = function()
		return "黑暗能量穿过了熔岩。"
	end,
}

logCHN:newLog{
	log = "Something in the floor clicks ominously, and suddenly the world spins around you!",
	fct = function()
		return "什么东西在地上发出了不祥的咔嗒声， 突然， 你周围的世界开始旋转！"
	end,
}

logCHN:newLog{
	log = "Something in the floor clicks ominously, and the crypt rearranges itself around you!",
	fct = function()
		return "什么东西在地上发出了不祥的咔嗒声， 地窖自己进行了重新组合！"
	end,
}

logCHN:newLog{
	log = "Something in the floor clicks ominously.",
	fct = function()
		return "什么东西在地上发出了不祥的咔嗒声。"
	end,
}

logCHN:newLog{
	log = "Something underfoot clicks ominously, and the crypt rearranges itself around you!",
	fct = function()
		return "你脚下什么东西发出了不祥的咔嗒声， 地窖自己进行了重新组合！"
	end,
}

logCHN:newLog{
	log = "Something beneath you clicks ominously.",
	fct = function()
		return "你脚下什么东西发出了不祥的咔嗒声。"
	end,
}

logCHN:newLog{
	log = "#YELLOW#The world spins around you!",
	fct = function()
		return "#YELLOW#你周围的世界开始旋转！"
	end,
}

logCHN:newLog{
	log = "#YELLOW#The air comes alive with terrible magics!",
	fct = function()
		return "#YELLOW#在可怕的魔法中空气似乎获得了生命！"
	end,
}

logCHN:newLog{
	log = "#PINK#Your summoned %s disappears.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#PINK#你召唤的 %s 消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#PINK#%s returns to the shadows.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#PINK#%s 回到了阴影之中。"):format(a)
	end,
}

logCHN:newLog{
	log = "You are unable to move!",
	fct = function()
		return "你无法移动！"
	end,
}

logCHN:newLog{
	log = "You have found a trap (%s)!",
	fct = function(a)
		if a:find("'s") then 
			local f,e=a:find("'s ")
			local owner=string.sub(a,1,f-1)
			local trapname=a:gsub(owner,""):gsub(" 's ","")
			a= npcCHN:getName(owner) .."的" ..trapCHN:getName(trapname)
		else a = trapCHN[a] or a 
		end
		return ("你发现了一个陷阱（ %s ）！"):format(a)
	end,
}

logCHN:newLog{
	log = "Can not switch control to this creature.",
	fct = function()
		return "无法切换至控制这个生物。"
	end,
}

logCHN:newLog{
	log = "#MOCCASIN#Character control switched to %s.",
	fct = function(...)
		return ("#MOCCASIN#角色切换至 %s 。"):format(...)
	end,
}

logCHN:newLog{
	log = "Can not give orders to this creature.",
	fct = function()
		return "无法对该生物发布指令。"
	end,
}

logCHN:newLog{
	log = "%s maximum action radius set to %d.",
	fct = function(...)
		return ("%s 的最大活动范围被设定为 %d 。"):format(...)
	end,
}

logCHN:newLog{
	log = "%s will stay near %s.",
	fct = function(a,b)
		return ("%s 将会待在 %s 身边。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s targets %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 的目标设定为 %s 。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "You cannot see!",
	fct = function()
		return "你看不见！"
	end,
}

logCHN:newLog{
	log = "You are silenced!",
	fct = function()
		return "你被沉默！"
	end,
}

logCHN:newLog{
	log = "You must wear this object to use it!",
	fct = function()
		return "你必须装备这件物品才能使用它！"
	end,
}

logCHN:newLog{
	log = "You can not use items during a battle frenzy!",
	fct = function()
		return "你在战斗狂热之中无法使用物品！"
	end,
}

logCHN:newLog{
	log = "You destroy %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你摧毁了 %s 。"):format(name)
	end,
}

logCHN:newLog{
	log = "You cannot use items on the world map.",
	fct = function()
		return "你不能在世界地图中使用物品。"
	end,
}

logCHN:newLog{
	log = "Your antimagic disrupts %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你的反魔法技能打断了 %s 。"):format(name)
	end,
}

logCHN:newLog{
	log = "You switch your weapons to: %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a):gsub("and", "和")
		return ("你切换了你的装备至： %s 。"):format(name)
	end,
}

logCHN:newLog{
	log = "You teleport %s into your hands.",
	fct = function(a)
		local name = objects:getObjectsChnName(a):gsub("and", "和")
		return ("你将 %s 传送到了手中。"):format(name)
	end,
}

logCHN:newLog{
	log = "You can not use the Orb with foes in sight (%s to the %s%s)",
	fct = function(a,b,c)
		a = npcCHN:getName(a)
		if b == "north" then b = "北"
		elseif b == "south" then b = "南"
		elseif b == "east" then b = "东"
		elseif b == "west" then b = "西"
		elseif b == "northeast" then b = "东北"
		elseif b == "northwest" then b = "西北"
		elseif b == "southeast" then b = "东南"
		elseif b == "southwest" then b = "西南"
		end
		if c == " - offscreen" then c = "- 在屏幕外" end
		return ("你无法在你的视野中有敌人的情况下使用水晶球。(%s，%s方向%s)"):format(a,b,c)
	end,
}

logCHN:newLog{
	log = "This does not seem to have any effect.",
	fct = function()
		return "似乎没有发生任何作用。"
	end,
}

logCHN:newLog{
	log = "You use the %s on the pedestal. There is a distant 'clonk' sound.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你在基座上使用了 %s 。你听到远处传来一声“咔嗒”声。"):format(name)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#%s briefly catches sight of you!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_RED#%s 发现了你的踪迹！"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#Something briefly catches sight of you!",
	fct = function()
		return "#LIGHT_RED#什么东西发现了你的踪迹！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_GREEN#Accepted quest '%s'! #WHITE#(Press 'j' to see the quest log)",
	fct = function(a)
		if questCHN[a] then
			a = questCHN[a].name
		end
		if a:find("Escort") then a= "护送" end
		return ("#LIGHT_GREEN#接受了任务“ %s ”！ #WHITE#（按下“j”查看任务日志）"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_GREEN#Quest '%s' status updated! #WHITE#(Press 'j' to see the quest log)",
	fct = function(a)
		if questCHN[a] then
			a = questCHN[a].name
		end
		return ("#LIGHT_GREEN#任务 “ %s ”状态已经更新！ #WHITE#（按下“j”查看任务日志）"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_GREEN#Quest '%s' completed! #WHITE#(Press 'j' to see the quest log)",
	fct = function(a)
		if questCHN[a] then
			a = questCHN[a].name
		end
		if a:find("Escort") then a= "护送" end
		return ("#LIGHT_GREEN#任务 “ %s ”完成！ #WHITE#（按下“j”查看任务日志）"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_GREEN#Quest '%s' is done! #WHITE#(Press 'j' to see the quest log)",
	fct = function(a)
		if questCHN[a] then
			a = questCHN[a].name
		end
		if a:find("Escort") then a= "护送" end
		return ("#LIGHT_GREEN#任务 “ %s ”完成！ #WHITE#（按下“j”查看任务日志）"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#Quest '%s' is failed! #WHITE#(Press 'j' to see the quest log)",
	fct = function(a)
		if questCHN[a] then
			a = questCHN[a].name
		end
		if a:find("Escort") then a= "护送" end
		return ("#LIGHT_RED#任务 “ %s ”失败！ #WHITE#（按下“j”查看任务日志）"):format(a)
	end,
}

logCHN:newLog{
	log = "Lore found: #0080FF#%s",
	fct = function(a)
		return ("发现手札：#0080FF# %s"):format(a)
	end,
}

logCHN:newLog{
	log = "You can read all your collected lore in the game menu, by pressing Escape.",
	fct = function()
		return "按下Esc键，进入游戏菜单你可以查看所有你已经收集的札记。"
	end,
}

logCHN:newLog{
	log = "You already have too many of this inscription.",
	fct = function()
		return "你已经拥有太多这种纹身。"
	end,
}

logCHN:newLog{
	log = "You have no more inscription slots.",
	fct = function()
		return "你没有更多纹身槽了。"
	end,
}

logCHN:newLog{
	log = "You are now inscribed with %s.",
	fct = function(...)
		return ("你的纹身更新为： %s 。"):format(...)
	end,
}

logCHN:newLog{
	log = "Your %s is depleted!",
	fct = function(...)
		return ("你的 %s 被耗尽！"):format(...)
	end,
}

logCHN:newLog{
	log = "%s notices you at the last moment!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s在最后时刻注意到了你！"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#You revel in attacking a weakened foe! (+%d hate)",
	fct = function(...)
		return ("#F53CBE#你沉醉于攻击一个虚弱的敌人！（+%d 仇恨）"):format(...)
	end,
}

logCHN:newLog{
	log = "You must wield a bow or a sling (%s)!",
	fct = function(...)
		return ("你必须装备一把弓或者投石索（ %s ）！"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough ammo left!",
	fct = function()
		return "你没有足够的弹药！"
	end,
}

logCHN:newLog{
	log = "You are disarmed!",
	fct = function()
		return "你被缴械了！"
	end,
}

logCHN:newLog{
	log = "You carefully avoid the trap (%s).",
	fct = function(a)
		if a:find("'s ") then 
			local f,e=a:find("'s ")
			local owner=string.sub(a,1,f-1)
			local trapname=a:gsub(owner,""):gsub("'s ","")
			a= npcCHN:getName(owner) .."的" ..trapCHN[trapname] or trapname
		else a = trapCHN[a] or a 
		end
		return ("你小心翼翼地躲过了陷阱（ %s ）。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#Your movements fuel your rampage! (+1 duration)",
	fct = function()
		return "#F53CBE#你的移动提升了你的暴走！（+1持续时间）"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#Your %s is immune to the teleportation and drops to the floor!",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("#LIGHT_RED#你的 %s 免疫传送而掉落到了地上！"):format(name)
	end,
}

logCHN:newLog{
	log = "Your shield crumbles under the damage!",
	fct = function()
		return "你的护盾在攻击下被打破！"
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#You leech a part of %s vim.",
	fct = function(a)
		if questCHN[a] then
			a = questCHN[a].name
		end
		return ("#AQUAMARINE#你吸收了 %s 部分活力。"):format(a)
	end,
}

logCHN:newLog{
	log = "You feel a surge of power as a powerful creature falls nearby.",
	fct = function()
		return "你感受到一股力量的涌动，附近有个强大的生物倒下。"
	end,
}

logCHN:newLog{
	log = "%s rips more animus from its victim. (+1 more soul)",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s从受害者处拿到了更多的灵魂。（+1灵魂）"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s feeds you hate from it's latest victim. (+%d hate)",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 从它的最后一个受害者提供了你的仇恨值（+%d 仇恨）"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#The cease to exist spell fizzles and cancels, leaving the timeline intact.",
	fct = function()
		return "#LIGHT_RED#当前法术失败而终止，时间线保持了稳定。"
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#You have gained one more life (%d remaining).",
	fct = function(...)
		return ("#AQUAMARINE#你额外获得了一条命（剩余%d生命数）"):format(...)
	end,
}

logCHN:newLog{
	log = "#FF0000#You carry too much--you are encumbered!",
	fct = function()
		return "#FF0000#你拿了太多东西——超重了！"
	end,
}

logCHN:newLog{
	log = "#FF0000#Drop some of your items.",
	fct = function()
		return "#FF0000#丢弃一些东西。"
	end,
}

logCHN:newLog{
	log = "#00FF00#You are no longer encumbered.",
	fct = function()
		return "#00FF00#你不再超重。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You feel the edges of time begin to fray!",
	fct = function()
		return "#LIGHT_RED#你感到时间的边际开始移位！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#Time feels more stable.",
	fct = function()
		return "#LIGHT_BLUE#时间变得更加稳定。"
	end,
}
logCHN:newLog{
	log = "#LIGHT_RED#You feel the edges of space begin to ripple and bend!",
	fct = function()
		return "#LIGHT_RED#你感到空间的边际开始弯曲振荡。"
	end,
}
logCHN:newLog{
	log = "#LIGHT_RED#You feel the edges of spacetime begin to ripple and bend!",
	fct = function()
		return "#LIGHT_RED#你感到时空的边际开始弯曲振荡。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#Spacetime feels more stable.",
	fct = function()
		return "#LIGHT_BLUE#时空变得更加稳定。"
	end,
}
logCHN:newLog{
	log = "#LIGHT_BLUE#Space feels more stable.",
	fct = function()
		return "#LIGHT_BLUE#空间变得更加稳定。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#Space and time both fight against your control!",
	fct = function()
		return "#LIGHT_RED#时间和空间都失去了控制！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#Space and time have calmed...  somewhat.",
	fct = function()
		return "#LIGHT_BLUE#时间和空间...稍微稳定了些。"
	end,
}

logCHN:newLog{
	log = "You do not have enough mana to activate %s.",
	fct = function(...)
		return ("你没有足够的法力值施展： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough souls to activate %s.",
	fct = function(...)
		return ("你没有足够的灵魂施展： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough stamina to activate %s.",
	fct = function(...)
		return ("你没有足够的体力值施展： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough vim to activate %s.",
	fct = function(...)
		return ("你没有足够的活力值施展： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough positive energy to activate %s.",
	fct = function(...)
		return ("你没有足够的正能量施展： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough negative energy to activate %s.",
	fct = function(...)
		return ("你没有足够的负能量施展： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough hate to activate %s.",
	fct = function(...)
		return ("你没有足够的仇恨值施展： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough energy to activate %s.",
	fct = function(...)
		return ("你没有足够的能量施展： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough mana to cast %s.",
	fct = function(...)
		return ("你没有足够的法力施展： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough stamina to use %s.",
	fct = function(...)
		return ("你没有足够的体力值使用： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough vim to use %s.",
	fct = function(...)
		return ("你没有足够的活力值使用： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough positive energy to use %s.",
	fct = function(...)
		return ("你没有足够的正能量使用： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough negative energy to use %s.",
	fct = function(...)
		return ("你没有足够的负能量使用： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough hate to use %s.",
	fct = function(...)
		return ("你没有足够的仇恨值使用： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You do not have enough energy to cast %s.",
	fct = function(...)
		return ("你没有足够的能量施展： %s"):format(...)
	end,
}

logCHN:newLog{
	log = "You fail to use %s due to your equilibrium!",
	fct = function(...)
		return ("由于你的失衡值过高你使用 %s 失败！"):format(...)
	end,
}

logCHN:newLog{
	log = "You fail to cast %s!",
	fct = function(...)
		return ("施展 %s 失败！"):format(...)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You lose control and unleash an anomaly!",
	fct = function()
		return "#LIGHT_RED#你失去控制产生了异常！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You fail to use %s due to your paradox!",
	fct = function(...)
		return ("#LIGHT_RED#由于你的紊乱值过高你使用 %s 失败！"):format(...)
	end,
}

logCHN:newLog{
	log = "%s behavior set to %s.",
	fct = function(...)
		return ("%s 的行动被设定为 %s 。"):format(...)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You have %s left.",
	fct = function(...)
		return ("#LIGHT_RED#你还剩下 %s 条命。"):format(...)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#From the brink of death you seem to be yanked to another plane.",
	fct = function()
		return "#LIGHT_RED#在死亡的边缘你突然被带到了另外一个地方。"
	end,
}

logCHN:newLog{
	log = "#00ffff#Welcome to level %d [%s].",
	fct = function(...)
		return ("#00ffff#欢迎来到等级 %d [ %s ]"):format(...)
	end,
}

logCHN:newLog{
	log = "%s has %s to spend. %s",
	fct = function(a,b,c)
		b = b:gsub("stat point%(s%)","属性点")
		b = b:gsub("class talent point%(s%)","职业技能点")
		b = b:gsub("generic talent point%(s%)","通用技能点")
		b = b:gsub("category point%(s%)","技能树解锁点")
		b = b:gsub("prodigies point%(s%)","觉醒技能点")
		if type(c) == "string" then
			c = c:gsub("Select ","在队伍中选择 ")
			c = c:gsub(" in the party list and press G to use them."," 角色，按下 G 键来分配点数。")
			c = c:gsub("Press p to use them","按下 P 键分配点数")
			c = c:gsub("Press G to use them","按下 G 键分配点数")
		end
		return ("%s 有 %s 可以使用。%s"):format(a,b,c)
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#You have gained one more life (%d remaining).",
	fct = function(...)
		return ("#AQUAMARINE#你获得了一次生命 (%d 剩余)。"):format(...)
	end,
}

logCHN:newLog{
	log = "You gain %0.2f gold from the transmogrification of %s.",
	fct = function(a,b)
		local name = objects:getObjectsChnName(b)
		return ("你获得了 %0.2f 金币，转化了 %s"):format(a,name)
	end,
}

logCHN:newLog{
	log = "#CRIMSON#Your timetravel has no effect on pre-determined outcomes such as this.",
	fct = function()
		return "#CRIMSON#你的时间穿越对这种已经预设好的结局没有任何作用。"
	end,
}

logCHN:newLog{
	log = "Bought: %s for %0.2f gold.",
	fct = function(a,b)
		local name = objects:getObjectsChnName(a)
		return ("购买：%s 花了 %0.2f 金币。"):format(name,b)
	end,
}

logCHN:newLog{
	log = "Sold: %s for %0.2f gold.",
	fct = function(a,b)
		local name = objects:getObjectsChnName(a)
		return ("出售： %s 获得 %0.2f 金币。"):format(name,b)
	end,
}

logCHN:newLog{
	log = "#00ff00#%sTalent %s is ready to use.",
	fct = function(...)
		return ("#00ff00#%s技能 %s 已经可以使用。"):format(...)
	end,
}

logCHN:newLog{
	log = "#LIGHT_GREEN#You have learnt to create poison gas traps!",
	fct = function()
		return "#LIGHT_GREEN#你学会了制造毒气陷阱！"
	end,
}

logCHN:newLog{
	log = "You collect a new ingredient: #LIGHT_GREEN#%s%s#WHITE#.",
	fct = function(a,b)
		b = changeElixir(b)
		return ("你搜集了一个新的材料: #LIGHT_GREEN#%s%s#WHITE#."):format(a,b)
	end,
}
logCHN:newLog{
	log = "You collect a new ingredient: #LIGHT_GREEN#%s%s (%d)#WHITE#.",
	fct = function(a,b,c)
		b = changeElixir(b)
		return ("你搜集了一个新的材料: #LIGHT_GREEN#%s%s (%d)#WHITE#."):format(a,b,c)
	end,
}

logCHN:newLog{
	log = "The damage shield reflects %d damage back to %s!",
	fct = function(...)
		return ("反射护盾反射了 %d 伤害给 %s ！"):format(...)
	end,
}


logCHN:newLog{
	log = "You have no more %s",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你不再拥有%s。"):format(name)
	end,
}
logCHN:newLog{
	log = "You have no more %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你不再拥有%s。"):format(name)
	end,
}
logCHN:newLog{
	log = "You cannot do that on the world map.",
	fct = function()
		return "你在世界地图上不能这样做。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#WARNING! Rej Arkatis, the master of the arena, appears!!!",
	fct = function()
		return "#LIGHT_RED#警告!瑞吉·阿卡提斯,竞技场之主，出现了!!!"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You may not change level without your own body!",
	fct = function()
		return "#LIGHT_RED#你只能用自己的身体离开地图!"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You may not leave the zone with this character!",
	fct = function()
		return "#LIGHT_RED#你不能用这个角色离开地图!"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You cannot escape your fate by leaving the level!",
	fct = function()
		return "#LIGHT_RED#你不能离开地图以求逃避命运!"
	end,
}

logCHN:newLog{
	log = "%s talent '%s%s' is disrupted by the mind parasite.",
	fct = function(a,b,c)
		a = npcCHN:getName(a)
		return ("%s 的技能 '%s%s' 被精神寄生虫干扰。"):format(a,b,c)
	end,
}

logCHN:newLog{
	log = "#{bold}##Source# performs a ranged critical strike against #Target#!#{normal}#",
	fct = function()
		return ("#{bold}##Source#对#Target#发起一次远程暴击!#{normal}#")
	end,
}
logCHN:newLog{
	log = "Showing no tactical information.",
	fct = function()
		return "不显示血条信息"
	end,
}
logCHN:newLog{
	log = "Showing healthbars only.",
	fct = function()
		return "只显示血条信息"
	end,
}
logCHN:newLog{
	log = "Showing big healthbars and tactical borders.",
	fct = function()
		return "显示大血条+边框"
	end,
}
logCHN:newLog{
	log = "Showing small healthbars and tactical borders.",
	fct = function()
		return "显示小血条+边框"
	end,
}

logCHN:newLog{
	log = "There is no way out of this level here.",
	fct = function()
		return "这里不是离开该层的出口。"
	end,
}

logCHN:newLog{
	log = "#CRIMSON##Source# steals life from #Target#!",
	fct = function()
		return "#CRIMSON##Source#从#Target#处吸取生命!"
	end,
}

logCHN:newLog{
	log = "%s is sleeping and unable to do this.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s正处于睡眠中，不能这样做。"):format(a)
	end,
}

logCHN:newLog{
	log = "#RED#Rising again, the Rat Lich's eyes glow with renewed energy!",
	fct = function()
		return "#RED#鼠巫妖再次站起，它的眼睛放射着能量的光辉！"
	end,
}

logCHN:newLog{
	log = "#ORCHID#Target out of range.  Hold <ctrl> to force all weapons to fire at targets out of ranges (%d - %d).",
	fct = function(...)
		return ("#ORCHID#目标超出范围。按住  <ctrl> 来强制射击超出范围(%d - %d)的目标."):format(...)
	end,
}


logCHN:newLog{
	log = "#ORCHID#Target out of range.  Hold <ctrl> to force your weapon to fire at targets beyond its range (%d).",
	fct = function(...)
		return ("#ORCHID#目标超出范围。按住  <ctrl> 来强制射击超出范围(%d)的目标."):format(...)
	end,
}