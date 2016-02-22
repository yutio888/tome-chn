logCHN:newLog{
	log = "Saving done.",
	fct = function()
		return "保存完毕。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#Online profile disabled(switching to offline profile) due to %s.",
	fct = function(a)
		if a == "no online profile active" then a = "未开启在线存档" end
		if a == "cheat mode skipping validation" then a = "Debug模式而跳过检测" end
		if a == "bad game addon version" then a = "错误的游戏模组版本" end
		return ("#LIGHT_RED#由于 %s ，在线存档无法运行（切换至离线存档）"):format(a)
	end,
}

logCHN:newLog{
	log = "#YELLOW#Connection to online server established.",
	fct = function()
		return "#YELLOW#连接至在线服务器。"
	end,
}

logCHN:newLog{
	log = "#YELLOW#Connection to online server lost, trying to reconnect.",
	fct = function()
		return "#YELLOW#与在线服务器的连接丢失，尝试重新连接。"
	end,
}

logCHN:newLog{
	log = "#YELLOW#Error report sent, thank you.",
	fct = function()
		return "#YELLOW#错误报告已发送，谢谢！"
	end,
}

logCHN:newLog{
	log = "%s picks up (%s.): %s%s.",
	fct = function(a,b,c,d)
		local name = objects:getObjectsChnName(d)
		return ("%s 拾取了（ %s ）：%s%s"):format( a, b, c,name)
	end,
}

logCHN:newLog{
	log = "%s has no room for: %s.",
	fct = function(a,b)
		local name = objects:getObjectsChnName(b)
		return ("%s 没有空间放置：%s。"):format(a,name)
	end,
}

logCHN:newLog{
	log = "There is nothing to pick up there.",
	fct = function()
		return "没什么可以拾取的东西。"
	end,
}

logCHN:newLog{
	log = "There is nothing to drop.",
	fct = function()
		return "没东西可以丢弃。"
	end,
}

logCHN:newLog{
	log = "%s drops on the floor: %s.",
	fct = function(a,b)
		local name = objects:getObjectsChnName(b)
		return ("%s 把 %s 丢在了地上。"):format(a,name)
	end,
}

logCHN:newLog{
	log = "%s is not wearable.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("%s 无法装备。"):format(name)
	end,
}

logCHN:newLog{
	log = "%s can not wear %s.",
	fct = function(a,b)
		local name = objects:getObjectsChnName(b)
		return ("%s 不能装备 %s。"):format(a,name)
	end,
}

logCHN:newLog{
	log = "%s can not wear: %s.",
	fct = function(a,b)
		local name = objects:getObjectsChnName(b)
		return ("%s 不能装备: %s。"):format(a,name)
	end,
}

logCHN:newLog{
	log = "%s can not wear (%s): %s (%s).",
	fct = function(a,b,c,d)
		local ns = b:gsub("in main hand","在主手"):gsub("in off hand","在副手"):gsub("psionic focus","心灵聚焦"):gsub("on fingers","在手指上"):gsub("around neck","在脖子上"):gsub("light source","以光源"):gsub("main armor","作为主护甲"):gsub("cloak","作为披风"):gsub("on head","在头上"):gsub("around waist","在腰间"):gsub("on hands","在手上"):gsub("on feet","在脚上"):gsub("tool","作为工具"):gsub("quiver","作为箭矢"):gsub("socketed gems","作为插入的宝石"):gsub("second weapon set: in main hand","作为第二套主手武器"):gsub("second weapon set: in off hand","作为第二套副手武器"):gsub("second weapon set: psionic focus","作为第二套心灵聚焦"):gsub("second weapon set: quiver","作为第二套箭矢")
		local name = objects:getObjectsChnName(c)
		if d == "not enough stat" then d = "属性点不足"
		elseif d == "not enough levels" then d = "等级不足"
		elseif d == "missing dependency" then d = "附属条件未达到"
		elseif d == "cannot use currently due to an other worn object" then c = "由于其他已装备物品， 暂时无法使用"
		end
		return ("%s 无法%s装备： %s （ %s ）"):format(a,ns,name,c)
	end,
}

logCHN:newLog{
	log = "%s wears: %s.",
	fct = function(a,b)
		local name = objects:getObjectsChnName(b)
		return ("%s 装备了： %s"):format(a,name)
	end,
}

logCHN:newLog{
	log = "%s wears (offslot): %s.",
	fct = function(a,b)
		local name = objects:getObjectsChnName(b)
		return ("%s 副手装备了： %s"):format(a,name)
	end,
}

logCHN:newLog{
	log = "%s wears (replacing %s): %s.",
	fct = function(a,b,c)
		local name = objects:getObjectsChnName(b)
		local name2 = objects:getObjectsChnName(c)
		return ("%s 装备（替换 %s）了： %s"):format(a,name,name2)
	end,
}

logCHN:newLog{
	log = "%s is still on cooldown for %d turns.",
	fct = function(...)
		return ("%s 还有 %d 回合才能冷却。"):format(...)
	end,
}

logCHN:newLog{
	log = "You don't see how to get there...",
	fct = function()
		return "你不知道怎么到达那里..."
	end,
}

logCHN:newLog{
	log = "You may not auto-explore with enemies in sight!",
	fct = function()
		return "你无法在附近有敌人的状况下使用自动探测！"
	end,
}

logCHN:newLog{
	log = "Ran for %d turns (stop reason: %s).",
	fct = function(a,b)
		if b == "at exit" then b = "在出口处"
		elseif b == "suffocating" then b = "窒息！"
		elseif b == "didn't move" then b = "无法移动"
		elseif b == "taken damage" then b = "承受伤害"
		elseif b == "losing health!" then b = "生命值下降！"
		elseif b == "interesting terrain" then b = "漂亮的风景"
		elseif b == "something interesting" then b = "有意思的东西"
		elseif b == "detrimental status effect" then b = "负面效果"
		elseif b == "at portal" then b = "在入口处"
		elseif b == "at door" then b = "在门旁"
		elseif b == "trap" then b = "陷阱"
		elseif b == "trap spotted" then b = "发现陷阱"
		elseif b == "died" then b = "死亡"
		elseif b == "checked door" then b = "检查这扇门"
		elseif b == "chat started" then b = "开始聊天"
		elseif b == "learnt lore" then b = "阅读文献"
		elseif b == "the path is blocked" then b = "道路被堵住了"
		elseif b == "at object (diggable)" then b = "在物品上（可挖掘）"
		elseif b == "terrain change on the left" then b = "左边地形发生变化"
		elseif b == "terrain change on the right" then b = "右边地形发生变化"
		elseif b == "golem out of sight" then b = "傀儡脱出视线"
		elseif b == "quitting" then b = "退出"
		elseif b == "saving" then b = "保存"
		elseif b == "Switching control" then b = "切换控制"
		elseif b == "grave" then b = "坟墓"
		elseif b == "weird pedestal" then b = "怪异的基座"
		elseif b == "dream" then b = "入梦"
		elseif b == "at object" then b = "在物品上"
		elseif b == "dialog is displayed" then b = "对话已显示"
		end
		return ("自动探索了%d回合（中断原因： %s）"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#{bold}#%s%s killed %s!#{normal}#",
	fct = function(c,a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("#{bold}#%s%s 杀死了 %s!#{normal}#"):format(c, a, b)
	end,
}

logCHN:newLog{
	log = "%s attacks %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 攻击了 %s."):format( a, b)
	end,
}

logCHN:newLog{
	log = "Resting starts...",
	fct = function()
		return "开始休息..."
	end,
}

logCHN:newLog{
	log = "Rested for %d turns (stop reason: %s).",
	fct = function(a,b)
		if b == "at exit" then b = "在出口处"
		elseif b == "suffocating" then b = "窒息！"
		elseif b == "didn't move" then b = "无法移动"
		elseif b == "taken damage" then b = "承受伤害"
		elseif b == "losing health!" then b = "生命值下降！"
		elseif b == "interesting terrain" then b = "漂亮的风景"
		elseif b == "something interesting" then b = "有意思的东西"
		elseif b == "detrimental status effect" then b = "负面效果"
		elseif b == "at portal" then b = "在入口处"
		elseif b == "at door" then b = "在门旁"
		elseif b == "trap" then b = "陷阱"
		elseif b == "trap spotted" then b = "发现陷阱"
		elseif b == "died" then b = "死亡"
		elseif b == "checked door" then b = "检查这扇门"
		elseif b == "chat started" then b = "开始聊天"
		elseif b == "learnt lore" then b = "阅读文献"
		elseif b == "the path is blocked" then b = "道路被堵住了"
		elseif b == "at object (diggable)" then b = "在物品上（可挖掘）"
		elseif b == "terrain change on the left" then b = "左边地形发生变化"
		elseif b == "terrain change on the right" then b = "右边地形发生变化"
		elseif b == "golem out of sight" then b = "傀儡脱出视线"
		elseif b == "quitting" then b = "退出"
		elseif b == "saving" then b = "保存"
		elseif b == "Switching control" then b = "切换控制"
		elseif b == "grave" then b = "坟墓"
		elseif b == "weird pedestal" then b = "怪异的基座"
		elseif b == "dream" then b = "入梦"
		elseif b == "at object" then b = "在物品上"
		elseif b == "dialog is displayed" then b = "对话已显示"
		end
		return ("休息了%d回合（中断原因： %s）"):format(a,b)
	end,
}

logCHN:newLog{
	log = "Rested for %d turns.",
	fct = function(...)
		return ("休息了%d回合."):format(...)
	end,
}

logCHN:newLog{
	log = "Digging starts...",
	fct = function()
		return "开始挖掘..."
	end,
}

logCHN:newLog{
	log = "Dug for %d turns.",
	fct = function(a)
		return ("挖了 %d 回合。"):format(a)
	end,
}

logCHN:newLog{
	log = "Dug for %d turns (stop reason: %s).",
	fct = function(a,b)
		if b == "at exit" then b = "在出口处"
		elseif b == "suffocating" then b = "窒息！"
		elseif b == "didn't move" then b = "无法移动"
		elseif b == "taken damage" then b = "承受伤害"
		elseif b == "losing health!" then b = "生命值下降！"
		elseif b == "interesting terrain" then b = "漂亮的风景"
		elseif b == "something interesting" then b = "有意思的东西"
		elseif b == "detrimental status effect" then b = "负面效果"
		elseif b == "at portal" then b = "在入口处"
		elseif b == "at door" then b = "在门旁"
		elseif b == "trap" then b = "陷阱"
		elseif b == "trap spotted" then b = "发现陷阱"
		elseif b == "died" then b = "死亡"
		elseif b == "checked door" then b = "检查这扇门"
		elseif b == "chat started" then b = "开始聊天"
		elseif b == "learnt lore" then b = "阅读文献"
		elseif b == "the path is blocked" then b = "道路被堵住了"
		elseif b == "at object (diggable)" then b = "在物品上（可挖掘）"
		elseif b == "terrain change on the left" then b = "左边地形发生变化"
		elseif b == "terrain change on the right" then b = "右边地形发生变化"
		elseif b == "golem out of sight" then b = "傀儡脱出视线"
		elseif b == "quitting" then b = "退出"
		elseif b == "saving" then b = "保存"
		elseif b == "Switching control" then b = "切换控制"
		elseif b == "grave" then b = "坟墓"
		elseif b == "weird pedestal" then b = "怪异的基座"
		elseif b == "dream" then b = "入梦"
		elseif b == "at object" then b = "在物品上"
		elseif b == "dialog is displayed" then b = "对话已显示"
		end
		return ("挖了%d回合（中断原因： %s）"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#LIGHT_GREEN#Personal New Achievement: %s!",
	fct = function(a)
		local key = require "data-chn123.achievements":getName(a)
		return ("#LIGHT_GREEN#新的个人成就：%s！"):format(key)
	end,
}

logCHN:newLog{
	log = "#LIGHT_GREEN#New Achievement: %s!",
	fct = function(a)
		local key = require "data-chn123.achievements":getName(a)
		return ("#LIGHT_GREEN#新成就：%s！"):format(key)
	end,
}

logCHN:newLog{
	log = "#GOLD#Personal New Achievement: %s!",
	fct = function(a)
		local key = require "data-chn123.achievements":getName(a)
		return ("#GOLD#新的个人成就：%s！"):format(key)
	end,
}

logCHN:newLog{
	log = "#GOLD#New Achievement: %s!",
	fct = function(a)
		local key = require "data-chn123.achievements":getName(a)
		return ("#GOLD#新成就：%s！"):format(key)
	end,
}

logCHN:newLog{
	log = "%s is still recharging.",
	fct = function(...)
		return ("%s 还在充能。"):format(...)
	end,
}

logCHN:newLog{
	log = "%s can not be used anymore.",
	fct = function(...)
		return ("%s 无法再继续使用了。"):format(...)
	end,
}

logCHN:newLog{
	log = "%s fails to disarm a trap (%s).",
	fct = function(a,b)
		if b:find("'s") then 
			local f,e=b:find("'s ")
			local owner=b:sub(1,f-1)
			local trapname=b:gsub(owner,""):gsub("'s ","")
			trapname = trapCHN:getName(trapname)
			owner = npcCHN:getName(owner)
			b=  owner .."的" .. trapname
		else b = trapCHN:getName(b)
		end
		return ("%s 拆除陷阱（ %s ）失败。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s disarms a trap (%s).",
	fct = function(a,b)
		a = npcCHN:getName(a)
		if b:find("'s") then 
			local f,e=b:find("'s ")
			local owner=b:sub(1,f-1)
			local trapname=b:gsub(owner,""):gsub("'s ","")
			trapname = trapCHN:getName(trapname)
			owner = npcCHN:getName(owner)
			b=  owner .."的" .. trapname
		else b = trapCHN:getName(b)
		end
		return ("%s 拆除了陷阱（ %s ）。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s triggers a trap (%s)!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		if b:find("'s") then 
			local f,e=b:find("'s ")
			local owner=b:sub(1,f-1)
			local trapname=b:gsub(owner,""):gsub("'s ","")
			trapname = trapCHN:getName(trapname)
			owner = npcCHN:getName(owner)
			b=  owner .."的" .. trapname
		else b = trapCHN:getName(b)
		end
		return ("%s 触发了陷阱（ %s ）！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "Saving game...",
	fct = function()
		return "保存游戏..."
	end,
}

logCHN:newLog{
	log = "You cannot currently leave the level.",
	fct = function()
		return "你现在无法离开本区域。"
	end,
}
