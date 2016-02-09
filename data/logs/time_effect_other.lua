
logCHN:newLog{
	log = "#Target# whirls around and a radiant shield surrounds them!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 旋转一圈，一层光明护盾在他周围形成！"):format(a)
	end,
}


logCHN:newLog{
	log = "#Target# is drained from light!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的光明被吸收了！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s light is back.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的光明回复了！"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE##Target# takes root.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s扎根了！"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE##Target# is no longer a badass tree.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再扎根。"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#The spell fizzles.",
	fct = function()
		return "#LIGHT_RED#法术失败了。"
	end,
}

logCHN:newLog{
	log = "#Target# is removed from time!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被从时间中移除！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is returned to normal time.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 返回了正常时间。"):format(a)
	end,
}

logCHN:newLog{
	log = "The very fabric of time alters around #target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的时间网开始变化。"):format(a)
	end,
}

logCHN:newLog{
	log = "The fabric of time around #target# stabilizes to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的时间网恢复了稳定。"):format(a)
	end,
}


logCHN:newLog{
	log = "The fabric of time around #target# returns to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的时间网开始恢复正常。"):format(a)
	end,
}
logCHN:newLog{
	log = "The powerful time-altering energies generate a restoration field on #target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("强大的时间能量在%s周围产生能量场。"):format(a)
	end,
}
logCHN:newLog{
	log = "The fabric of time around #target# returns to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s周围的时间线恢复正常。"):format(a)
	end,
}
logCHN:newLog{
	log = "#LIGHT_RED##Target# is out of sight of its master; direct control will break!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 离开了它主人的视线，对它的控制将中断！"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You lost sight of your golem for too long; direct control is broken!",
	fct = function()
		return "#LIGHT_RED#傀儡离开你的视线时间太长， 控制被中断了！"
	end,
}

logCHN:newLog{
	log = "#Target# looks a little pale around the edges.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 看上去变得暗淡了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is firmly planted in reality.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 返回了现实世界。"):format(a)
	end,
}

logCHN:newLog{
	log = "The fabric of time alters around #target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的时间网开始发生变化。"):format(a)
	end,
}

logCHN:newLog{
	log = "The fabric of time around #target# stabilizes.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的时间网稳定了下来。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is taking damage received in the past!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 受到过去累积的伤害！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# stops taking damage received in the past.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再受到过去累积的伤害。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is paralyzed!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 痳痹了！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is not paralyzed anymore.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再痳痹了！"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You unfold the spacetime continuum to a previous state!",
	fct = function()
		return "#LIGHT_BLUE#你打开了时空连续体探知未来！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#The see the threads spell fizzles and cancels, leaving you in this timeline.",
	fct = function()
		return "#LIGHT_RED#时空抉择法术失败了，你停留在了当前时间线。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You unfold the space time continuum to the start of the time threads!",
	fct = function()
		return "#LIGHT_BLUE#你打开了时间连续体， 开始控制时间线！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You've altered your destiny and will not be pulled into the past.",
	fct = function()
		return "#LIGHT_RED#你改变了你的命运，无法再回到过去。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You've been pulled into the past!",
	fct = function()
		return "#LIGHT_BLUE#你回到了过去！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You've been returned to the present!",
	fct = function()
		return "#LIGHT_BLUE#你回到了现在！"
	end,
}

logCHN:newLog{
	log = "#Target# lifeline is being severed!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的生命线被离断！"):format(a)
	end,
}

logCHN:newLog{
	log = "Spacetime has stabilized around #Target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的时空变得稳定。"):format(a)
	end,
}

logCHN:newLog{
	log = "The fabric of spacetime around #Target# has returned to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的时空回到了正常。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has partially removed itself from the timeline.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 部分从时间线中消失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has returned fully to the timeline.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 完全返回了时间线内。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is covered in a veil of shadows!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 笼罩在暗影之中！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer covered by shadows.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再遮蔽在暗影中。"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You enter a zero gravity zone, beware!",
	fct = function()
		return "#LIGHT_BLUE#注意！你进入了失重区域！"
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s's remains glow with a strange light.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s的尸体发出了奇怪的光芒。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#The corpse of the %s pulls itself up to fight for you.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s的尸体又站了起来，协助你战斗。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s's mania hastens %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s的狂热加速了%s。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#F53CBE#The air around %s grows cold and terrifying shapes begin to coalesce. A nightmare has begun.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s周围的空气开始变得冰冷并形成了一种令人恐怖的形状，噩梦开始了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s suffers an unfortunate end.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s的厄运终结。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s suffers an unfortunate blow.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s遭受了厄运的打击。"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You begin reloading.",
	fct = function()
		return "#LIGHT_BLUE#你开始装填弹药。"
	end,
}

logCHN:newLog{
	log = "Your %s is full.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你的 %s 满了。"):format(a)
	end,
}


logCHN:newLog{
	log = "强大的时空能量在 #target#周围形成能量场。",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("强大的时空能量在%s周围形成能量场。"):format(a)
	end,
}




logCHN:newLog{
	log = "#target#周围的时间线恢复正常。",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s周围的时间线恢复正常。"):format(a)
	end,
}

logCHN:newLog{
	log = "#CRIMSON##Target# is wreathed in flames on the brink of death!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#CRIMSON#%s在死亡边缘被火焰笼罩！"):format(a)
	end,
}
logCHN:newLog{
	log = "#CRIMSON#The flames around #target# vanish.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#CRIMSON#%s周围的火焰消散了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#An illusion appears around #Target# making %s appear human.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_BLUE#%s周围的幻影让它看起来像活着一样。"):format(a)
	end,
}
logCHN:newLog{
	log = "#LIGHT_BLUE#The illusion covering #Target# disappears.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_BLUE#%s周围的幻影消失了。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is suffocating!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s进入窒息状态！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# can breathe again",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s能够呼吸了"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# fades!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s消失了！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# retunes the fabric of spaceime.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s返回了现实时间！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s is back to the normal timeflow.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("在%s中沉睡了无数年的生物被唤醒了！"):format(a)
	end,
}

logCHN:newLog{
	log = "Reality smears around #Target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的时空扭曲了。"):format(a)
	end,
}

logCHN:newLog{
	log = "Reality around #Target# is coherent again.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的时空恢复了连贯。"):format(a)
	end,
}

