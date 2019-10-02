--alarm
logCHN:newLog{
	log = "@Target@ triggers an alarm!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 触发了警报！"):format(a)
	end,
}

logCHN:newLog{
	log = "@Target@ moves onto the wormhole.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 踩中了虫洞。！"):format(a)
	end,
}

logCHN:newLog{
	log = "An alarm rings!",
	fct = function()
		return "警报响了！"
	end,}

logCHN:newLog{
	log ="%s appears out of the thin air!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从空气中出现了！"):format(a)
	end,}

logCHN:newLog{
	log = "@Target@ seems less active.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 变得昏昏欲睡。"):format(a)
	end,
}

logCHN:newLog{
	log = "@Target@ triggers a burning curse!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 触发了燃烧诅咒！"):format(a)
	end,
}

logCHN:newLog{
	log = "@Target@ walks on a trap, there is a loud noise.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 踩到了陷阱，发出了很大的响声。"):format(a)
	end,
}

logCHN:newLog{
	log = "@Target@ activates a trap, and its magical energies change.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 激活了陷阱，魔法能量变化了。"):format(a)
	end,
}
logCHN:newLog{
	log = "@Target@ walks on a trap, and the beam changes.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 踩到了陷阱，射线变化了。"):format(a)
	end,
}
logCHN:newLog{
	log =  "@Target@ walks on a poison spore.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s踩到了毒性孢子。"):format(a)
end,
}
logCHN:newLog{
	log = "The poison spore looks somewhat drained.",
	fct = "毒性孢子的能量似乎被抽取了",
}

logCHN:newLog{
	log = "A poisonous vine strikes at @Target@!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 受到剧毒藤蔓的攻击！"):format(a)
	end,
}
logCHN:newLog{
	log = "Flames start to appear around @target@.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的周围出现了火焰"):format(a)
	end,
}
logCHN:newLog{
	log = "Cold flames start to appear around @target@.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的周围出现了冰冷火焰"):format(a)
	end,
}
logCHN:newLog{
	log = "A stream of acid gushes onto @target@!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("一股酸液击中了 %s ！"):format(a)
	end,
}

logCHN:newLog{
	log = "A bolt of fire blasts onto @target@!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("一枚火球击中了 %s ！"):format(a)
	end,
}

logCHN:newLog{
	log = "A bolt of ice blasts onto @target@!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("一枚冰弹击中了 %s ！"):format(a)
	end,
}

logCHN:newLog{
	log = "A bolt of lightning fires onto @target@!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("一枚闪电箭击中了 %s ！"):format(a)
	end,
}

logCHN:newLog{
	log = "A stream of poison gushes onto @target@!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("一股毒液击中了 %s ！"):format(a)
	end,
}
logCHN:newLog{
	log = "A powerful blast of fire blasts onto @target@!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("一枚强力火球击中了 %s ！"):format(a)
	end,
}

logCHN:newLog{
	log = "@Target@ is blasted with anti-magic forces!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("反魔能量击中了 %s ！"):format(a)
	end,
}

logCHN:newLog{
	log = "@Target@ is teleported away.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被传送了。"):format(a)
	end,
}
logCHN:newLog{
	log = "%s is teleported away.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被传送了。"):format(a)
	end,
}
logCHN:newLog{
	log = "%s resists being teleported!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗传送!"):format(a)
	end,
}
logCHN:newLog{
	log = "@Target@ slides on a rock!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 滑倒在石头上！"):format(a)
	end,
}

logCHN:newLog{
	log = "@Target@ triggers a water jet!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 触发了一个喷水器！"):format(a)
	end,
}

logCHN:newLog{
	log = "@Target@ is caught by a water siphon!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被虹吸陷阱困住了！"):format(a)
	end,
}

logCHN:newLog{
	log = "@Target@ is caught in a web!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 陷入网中！"):format(a)
	end,
}

logCHN:newLog{
	log = "Cold flames start to appear arround @target@.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("冷火在%s周围散落。"):format(a)
	end,
}

logCHN:newLog{
	log = "Flames start to appear arround @target@.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("火焰在%s周围散落。"):format(a)
	end,
}

logCHN:newLog{
	log = "@Target@ shimmers briefly.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s在闪烁。"):format(a)
	end,
}
logCHN:newLog{
	log = "@Target@ is caught in a distorted pocket of time!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被困在扭曲的时间中!"):format(a)
	end,
}
logCHN:newLog{
	log = "@Target@ is caught in an extremely distorted pocket of time!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被困在极度扭曲的时间中！"):format(a)
	end,
}