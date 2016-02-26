logCHN:newLog{
	log = "#Target# is silenced!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被沉默！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is not silenced anymore.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再被沉默。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s mind is shattered.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的精神被操控。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s's mind recovers from the domination.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的精神摆脱了支配。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# collapses.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的精神瓦解。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s will is shattered.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的意志受到扰乱。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# regains some of its will.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 恢复了他的意志。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# lashes out with pure willpower.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的意志受到鼓舞。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s willpower rush ends.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 鼓舞意志消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is weakened by the gloom.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s被黑暗所削弱。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is no longer weakened.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s不再被削弱。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# moves reluctantly!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s 移动受黑暗影响。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# overcomes the gloom.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 战胜了黑暗。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is stunned with fear!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s 被恐惧所震慑。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is lost in despair!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s 在绝望中迷失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is dismayed!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s 陷入惊慌失措。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# overcomes the dismay",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 恢复了理智。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is being stalked by #Source#!",
	fct = function(a,b)	
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("#F53CBE#%s 被 %s 追踪！。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is no longer being stalked by #Source#.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("#F53CBE#%s 不再被 %s 追踪。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#Target# has been beckoned.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被召唤。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer beckoned.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再被召唤。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s struggles against the beckoning.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s 挣扎着摆脱召唤。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s is jolted to attention by the damage and is no longer being beckoned.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s 受到伤害，召唤被打断了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has been overwhelmed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被压制。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer overwhelmed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再受到压制。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has been harassed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 陷入疲倦。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer harassed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 摆脱了疲倦。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# has been dominated!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s 受到支配！"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is no longer dominated.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s 不再受到支配。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is writhing in agony!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 陷入垂死挣扎！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer writhing in agony.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 摆脱了垂死挣扎。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has heard the hateful whisper!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 听到了憎恨私语！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# no longer hears the hateful whisper.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再听到憎恨私语。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# slows in the grip of madness!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s陷入疯狂之中速度减缓了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# overcomes the madness.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了疯狂。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is stunned by madness!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s陷入疯狂之中而被震慑！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# overcomes the madness",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s战胜了疯狂。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is lost in madness!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s陷入了疯狂！"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# has been maligned!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s 被恶性感染！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer maligned.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s 摆脱了恶性感染."):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# becomes paranoid!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s 陷入了妄想！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer paranoid",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 摆脱了妄想。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s struggles against the paranoia.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s挣扎着摆脱妄想。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Source# attacks #Target# in a fit of paranoia.",
	fct = function()
		return "#F53CBE##Source#妄想发作攻击了#Target#。"
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s ignores the fear!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s无视了恐惧！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the fear!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了恐惧！"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is in despair!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s陷入绝望！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer in despair",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了绝望。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# becomes terrified!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s陷入了惊恐！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer terrified",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了惊恐。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# becomes distressed!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s陷入了痛苦！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer distressed",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了痛苦。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# becomes haunted!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s陷入了纠缠！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer haunted",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了纠缠。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s is struck by fear of the %s effect.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("#F53CBE#%s受到%s效果影响受到伤害。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# becomes tormented!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s受到折磨！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer tormented",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再受到折磨。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s is tormented by a vision!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s受到幻象折磨！"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# becomes panicked!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s陷入恐慌！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer panicked",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了恐慌。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s struggles against the panic.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s挣扎着摆脱恐慌。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#You panic and flee from %s.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#你因为恐惧而逃离%s。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Source# panics but fails to flee from #Target#.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("#F53CBE#%s恐惧而试图逃离%s,但是失败了。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#Target# enters a frenzy!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s进入狂热状态！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer frenzied.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的狂热状态消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "A powerful kinetic shield forms around #target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s四周形成了念力护盾。"):format(a)
	end,
}

logCHN:newLog{
	log = "The powerful kinetic shield around #target# crumbles.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的念力护盾消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "A powerful thermal shield forms around #target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 获得了热能护盾。"):format(a)
	end,
}

logCHN:newLog{
	log = "The powerful thermal shield around #target# crumbles.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的热能护盾消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "A powerful charged shield forms around #target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s获得了充电护盾。"):format(a)
	end,
}

logCHN:newLog{
	log = "The powerful charged shield around #target# crumbles.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的充电护盾消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "Energy starts pouring from the gem into #Target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从宝石中吸收能量。"):format(a)
	end,
}

logCHN:newLog{
	log = "The flow of energy from #Target#'s gem ceases.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s停止从宝石中吸收能量。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# enters a telekinetic archer's trance!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s进入念动射击状态！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer in a telekinetic archer's trance.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s脱离了念动射击状态。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is being driven mad by the void.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被卷入虚空变得疯狂。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has survived the void madness.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从虚空的疯狂中幸存了下来。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is lost in a waking nightmare.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s陷入了清醒梦魇。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the nightmare.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了清醒梦魇。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s succumbs to the nightmare!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s受噩梦控制！"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is plagued by inner demons!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s受心魔困扰。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is freed from the demons.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了心魔。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is hexed!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s受邪术影响！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the hex.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了邪术。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is entralled.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被迷惑。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is free from the domination.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了支配。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# seems more aware.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s变得更加敏锐。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s awareness returns to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了正常。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# aims carefully.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s仔细地瞄准。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# aims less carefully.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再仔细瞄准。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# goes into a killing frenzy.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s陷入杀戮狂热。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# calms down.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s冷静了下来。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s dies when its frenzy ends!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s死于它的狂热！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s's blood frenzy intensifies!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s狂热加剧！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# gains extra life.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s获得了额外的生命值。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s revels in the spilt blood and grows stronger!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s浴血狂欢，力量暴涨！"):format(a)
	end,
}
logCHN:newLog{
	log = "%s no longer revels in blood quite so much.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s冷静下来。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# loses extra life.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s失去了额外的生命值。"):format(a)
	end,
}
logCHN:newLog{
	log = "%s's increased life fades, leaving it stunned by the loss.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s失去了额外的生命值，并被Boss震慑。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# begins rampaging!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s开始暴走！"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is no longer rampaging.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s停止了暴走。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s has shrugged off %d damage and is ready for more.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s豁免了%d伤害，仍意犹未尽。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#F53CBE#Your rampage is invigorated by the intense onslaught! (+1 duration)",
	fct = function()
		return "#F53CBE#你的猛攻强化了你的暴走！（+1持续时间）。"
	end,
}

logCHN:newLog{
	log = "#F53CBE#You feel your rampage slowing down. (-1 duration)",
	fct = function()
		return "#F53CBE#你感受到你的暴走开始减速。（-1持续时间）。"
	end,
}

logCHN:newLog{
	log = "#Target# begins hunting %s / %s.",
	fct = function(a,b,c)
		a = npcCHN:getName(a)
		if actorCHN[b] then
			b = actorCHN[b]
		end
		if actorCHN[c] then
			c = actorCHN[c]
		end
		return ("%s开始猎杀 %s / %s。"):format(a,b,c)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer hunting %s / %s.",
	fct = function(a,b,c)
		a = npcCHN:getName(a)
		if actorCHN[b] then
			b = actorCHN[b]
		end
		if actorCHN[c] then
			c = actorCHN[c]
		end
		return ("%s停止猎杀 %s / %s。"):format(a,b,c)
	end,
}

logCHN:newLog{
	log = "#F53CBE#The death of your prey feeds your hate. (+%d hate)",
	fct = function(a)
		return ("#F53CBE#猎物的死亡增加了你的仇恨。（+%d仇恨）。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is outmaneuvered.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s受到运筹帷幄影响。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer outmaneuvered.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再受到运筹帷幄影响。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s has lost %d %s.",
	fct = function(a,...)
		a = npcCHN:getName(a)
		return ("%s失去了 %d %s。"):format(a,...)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer mimicking a previous victim.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再仿生于前一个目标。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s is mimicking %s. (no gains).",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s正在仿生%s（无增益）。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s is mimicking %s. (%+d %s)",
	fct = function(a,b,...)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s正在仿生%s（%+d %s）。"):format(a,b,...)
	end,
}

logCHN:newLog{
	log = "#Target# enters a state of bloodlust.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s获得嗜血状态。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s morale has been lowered.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的斗志被削弱。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# roars triumphantly.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s扬起怒吼。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer inspired.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s冷静了下来。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has regained its confidence.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了斗志。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# starts summoning at high speed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s开始快速召唤。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s frantic summoning ends.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的疯狂召唤效果消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# higher mental functions have been imparied.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的高级精神功能受到破坏。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s regains it's senses.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的恢复了它的感知力。"):format(a)
	end,
}

logCHN:newLog{
	log = "A psychic field forms around #target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s周围产生一圈超能领域。"):format(a)
	end,
}

logCHN:newLog{
	log = "The psychic field around #target# crumbles.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s周围的超能领域破碎了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s mind has been invaded!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s精神被入侵！"):format(a)
	end,
}logCHN:newLog{
	log = "#Target# is free from the mental invasion.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了精神入侵。"):format(a)
	end,
}


logCHN:newLog{
	log = "#Target# is gaining feedback.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s正在获取反馈值"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer gaining feedback.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再获取反馈值"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s subconscious has been focused.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s潜意识里集中了。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s subconscious has returned to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的潜意识回复了正常。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has been put to sleep.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s陷入沉睡。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is in a deep sleep.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s陷入沉睡。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer sleeping.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从沉睡中清醒。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is lost in a nightmare.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s陷入噩梦中。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the nightmare.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了噩梦。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# had a restless night.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s处于不眠之夜中。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has recovered from poor sleep.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从不安的睡眠中恢复。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is suffering from insomnia.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s失眠了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer suffering from insomnia.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再失眠。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s mental functions have been impaired.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的精神被削弱。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s dreams have been broken.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的梦境破碎了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# regains hope.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了希望。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s focuses.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的潜能爆发了。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s loses some focus.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再集中意志。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s is surrounded by antimagic forces.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的身体被反魔能量环绕。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s antimagic forces vanishes.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s周身的反魔能量消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s succumbs to heightening fears!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s死于恐惧加深！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is infected with a mind parasite.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被精神寄生虫感染"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is free from the mind parasite.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了精神寄生虫"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# glints with a crystaline aura",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s周围闪烁着水晶领域"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is no longer glinting.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s周围不再闪光。"):format(a)
	end,
}

logCHN:newLog{
	log = "A psionic shield forms around #target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s周围形成一层灵能护盾。"):format(a)
	end,
}
logCHN:newLog{
	log = "The psionic shield around #target# crumbles.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s周围的灵能护盾破碎了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is cursed!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被诅咒了!"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer cursed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再被诅咒"):format(a)
	end,
}
