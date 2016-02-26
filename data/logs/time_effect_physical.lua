logCHN:newLog{
	log = "#Target#'s power is greatly reduced!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的强度急剧下降！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# power has recovered.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的强度恢复了！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is gaining tempo.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 开始进入节奏。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# loses their tempo.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 丢失了节奏。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# loses speed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 速度减慢。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s brain isn't quite working right!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的大脑不能正常工作了！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# regains their concentration.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 恢复了注意力"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# starts to bleed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 开始流血。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# stops bleeding.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 停止流血。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# starts regenerating health quickly.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 开始快速回复生命值。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# stops regenerating health quickly.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 停止了快速回复生命值。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is poisoned!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 中毒了！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# stops being poisoned.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 中毒效果消失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is poisoned and cannot move!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 中毒并且无法移动！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer poisoned.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 中毒效果消失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is on fire!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s着火了！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# stops burning.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s身上的火熄灭了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is stunned by the burning flame!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被燃烧的火焰震慑！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is not stunned anymore.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再被震慑。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is stunned!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被震慑！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is disarmed!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被缴械！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# rearms.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 重新拿起了武器。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is constricted!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被扼制！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free to breathe.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 恢复了呼吸。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is dazed!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被眩晕！。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is not dazed anymore.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 从眩晕中恢复。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# tries to evade attacks.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 闪避攻击。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# speeds up.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 速度加快。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# slows down.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 速度减慢了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer evading attacks.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再闪避攻击。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# loses sight!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 失明了！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# recovers sight.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 恢复了视力。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s skin turns to stone.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的皮肤变成了石头"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s skin returns to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的皮肤恢复常态"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s skin looks a bit thorny.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的皮肤变得坚硬"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is less thorny now.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的皮肤不再坚硬"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is frozen to the ground!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被冻结在原地！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# warms up.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的坚冰融化了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is encased in ice!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被冻结在冰块中！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the ice.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 从冰块中解脱。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# radiates power.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 辐射出力量。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s aura of power vanishes.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的力量光环消失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# takes cover under its shell.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 以它的甲壳作为护盾。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# leaves the cover of its shell.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 失去了甲壳护盾。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# lessens the pain.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 可以无视疼痛。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# feels pain again.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 重新感受到疼痛。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# attunes to the wild.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s和自然相和谐。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is no longer one with nature.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 重新感受到疼痛。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# rejects blight!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了枯萎能量！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is susceptible to blight again",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 对枯萎抵抗力下降。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s armour is damaged!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的护甲破损了！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s armour is more intact.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的护甲恢复了。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s fighting ability is impaired!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的战斗能力被削弱了！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s ability to fight has recovered.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的战斗能力恢复了。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is pinned to the ground.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被定身在原地。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer pinned.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 摆脱了定身。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# looks menacing.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s看上去更具威胁。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# looks less menacing.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s看上去不再更具威胁。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is crippled.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被致残。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is not cripple anymore.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 从致残效果中恢复。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is surrounded by a thick smoke.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被浓烟围绕。"):format(a)
	end,
}

logCHN:newLog{
	log = "The smoke around #target# dissipate.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s周围的浓烟消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# attunes to the damage.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s能忍受伤害。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer attuned.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s忍受伤害能力消失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# prepares for the next kill!.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s准备好了攻击下一个目标！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# slows down.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s放慢了速度。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# turns into pure lightning!.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s变成了一道闪电！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is back to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了正常。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s throat seems to be burning.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的喉咙里喷射出火焰。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s throat seems to cool down.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的火焰平息了下来。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is engaged in a grapple!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s进入抓取状态！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has released the hold.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s脱离抓取状态。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is grappled!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被抓取！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the grapple.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s脱离抓取。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is being crushed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被击碎。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has escaped the crushing hold.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s脱离了击碎效果。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is being strangled.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被掐住了喉咙。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has escaped the strangle hold.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从扼喉中逃脱。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is maimed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被致残。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has recovered from the maiming.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从致残效果中恢复。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is moving defensively!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s获得防御步法。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# isn't moving as defensively anymore.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的防御步法消失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has been set up!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被倒立起来！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has survived the set up.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了平衡。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is recovering from the damage!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从伤害中恢复。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has finished recovering.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s停止了复原。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is grabbed by a stone vine.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被石藤缠住。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the stone vine.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从石藤的纠缠中逃脱。"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE##Target# is bound by telekinetic forces!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s被念力困住。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# shakes free of the telekinetic binding",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从念力约束中逃脱。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# shakes off the crushing forces.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s脱离压碎效果。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is moving freely.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s可以自由移动。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is moving less freely.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s自由移动效果消失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# feels a surge of adrenaline.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被注入了肾上腺素。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s adrenaline surge has come to an end.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的肾上腺素效果消失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has been weakened.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被削弱。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s is no longer weakened.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再被削弱。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# becomes more vulnerable to fire.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s变得更容易受到火焰伤害。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is less vulnerable to fire.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了火焰抗性。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# becomes more vulnerable to cold.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s变得更容易受到寒冰伤害。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is less vulnerable to cold.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了寒冰抗性。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# becomes more vulnerable to nature.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s变得更容易受到自然伤害。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is less vulnerable to nature.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了自然抗性。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# becomes more vulnerable to physical.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s变得更容易受到物理伤害。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is less vulnerable to physical.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了物理抗性。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has a cursed wound!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s遭受了被诅咒的创伤。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# no longer has a cursed wound.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的诅咒创伤消失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has re-opened a cursed wound!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s再次遭受被诅咒的创伤。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has been illuminated.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s受到冷光效果。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer illuminated.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的冷光效果消失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s magic has been disrupted.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的魔法力量被干扰。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s is no longer disrupted.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的魔法力量不再被干扰。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# resonates with the damage.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s与受到的伤害产生共鸣。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer resonating.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再与伤害共鸣。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is protected by a layer of thick leaves.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被一层厚厚的叶刃保护着。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# cover of leaves falls apart.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的叶刃保护消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#%s is being ravaged by distortion!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_RED#%s被疯狂扭曲了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer being ravaged.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再被疯狂扭曲。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer distorted.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再被扭曲。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is disabled.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s生活不能自理。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is not disabled anymore.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了能力。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is in anguish.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s处于极度痛苦中。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer in anguish.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s解除了痛苦。"):format(a)
	end,
}


logCHN:newLog{
	log = "#Target# is speeding up.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s速度加快。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is slowing down.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s速度减慢。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# become impervious to physical effects.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s对物理状态免疫。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is less impervious to physical effects.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再对物理状态免疫。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s acid damage is more potent.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的酸性伤害增加。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s acid damage is no longer so potent.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的酸性伤害不再增加。"):format(a)
	end,
}
logCHN:newLog{
	log = "%s's corrosive nature intensifies!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的自然腐蚀之力增强了！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s nature damage is more potent.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的自然伤害增加。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s nature damage is no longer so potent.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的自然伤害不再增加"):format(a)
	end,
}
logCHN:newLog{
	log = "%s's natural acid becomes more concentrated!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的自然酸化之力增强了！"):format(a)
	end,
}


logCHN:newLog{
	log = "#Target# is corroded.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被侵蚀。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has shook off the effects of their corrosion.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再被侵蚀。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is covered in slippery moss!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被光滑苔藓覆盖"):format(a)
	end,
}


logCHN:newLog{
	log = "#Target# is free from the slippery moss.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了光滑苔藓"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# hardens its skin.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的皮肤变硬了"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# prepares for the next kill!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s为下一次杀戮做好了准备!"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# defiantly reasserts %s connection to nature!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s重新和自然建立联系!"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# stops restoring Equilibrium.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再回复失衡值。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is stunned further! (now %d turns)",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s被进一步震慑了!(现在%d回合)"):format(a,b)
	end,
}
logCHN:newLog{
	log = "#Target# is poised to strike!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s准备作战！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# rolls to avoid some damage!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s进行滚动以避免伤害！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# has sped up!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s速度上升！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is #GREEN#INFESTED#LAST# with parasitic leeches!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被寄生虫#GREEN#寄生#LAST#了！ "):format(a)
	end,
}
logCHN:newLog{
	log = "Some leeches drop off %s!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("寄生虫从%s处脱落！ "):format(a)
	end,
}


--stone warden
logCHN:newLog{
	log = "#Target# is seized by a stone vine.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被岩石藤蔓抓住了。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is free from the stone vine.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s脱离了岩石藤蔓。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is encased in a stone shield.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s进入了岩石护盾中。"):format(a)
	end,
}
logCHN:newLog{
	log = "The stone shield around #Target# %s",
	fct = function(a,b)
		a = npcCHN:getName(a)
		if b:find("explode") then b = "爆炸了！"
		else b = "破碎了。" end
		return ("%s周围的岩石护盾%s"):format(a,b)
	end,
}
logCHN:newLog{
	log = "#Target# begins protecting %s friends with a stone shield.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s开始用岩石护盾保护周围的%s朋友。"):format(a,b)
	end,
}
logCHN:newLog{
	log = "#Target# is no longer protecting anyone.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不在保护任何人。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is protected by a stone shield.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被岩石护盾保护。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is less protected.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再被保护。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is imbued by the power of the Stone.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s充满了岩石力量。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is abandoned by the Stone's power.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被岩石力量抛弃了。"):format(a)
	end,
}

--orc DLC
logCHN:newLog{
	log = "#Target# is crushed by the iron grip.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被铁腕碾压。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the iron grip.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从铁腕中脱离。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# tweaks some of 他的 bullets.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 调整了部分弹药."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# tweaks some of 她的 bullets.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 调整了部分弹药."):format(a)
	end,
}


logCHN:newLog{
	log = "#Target# is focuses on firing.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 集中精力开火。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is less focused.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再集中精力。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# disappears from sight.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 从视线中消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# re-appears.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 重新出现了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# uses a pain suppressor salve.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 使用了痛苦压制药剂"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is not affected anymore by the salve.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再受药剂影响。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# uses a frost salve.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 使用了冰霜药剂。"):format(a)
	end,
}


logCHN:newLog{
	log = "#Target# uses a fiery salve.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 使用了烈火药剂。"):format(a)
	end,
}



logCHN:newLog{
	log = "#Target# uses a water salve.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 使用了静水药剂。"):format(a)
	end,
}



logCHN:newLog{
	log = "#Target# uses an unstoppable force salve.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 使用了势不可挡药剂。"):format(a)
	end,
}



logCHN:newLog{
	log = "#Target# supercharges all tinkers.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 超频了所有配件。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s supercharge is fading.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的超频结束了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# overcharges saw motors.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 超频了链锯引擎。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s saw motors are back to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的链锯引擎恢复常态。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is #ORANGE#INFESTED#LAST# with ritch larvae!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被里奇幼虫#ORANGE#寄生#LAST# !"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# internal structure metallises.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 内在结构金属化。."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# internal structure returns to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 内在结构恢复正常。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# revels in the pain.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 在苦痛中狂欢。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# no longer feels strong.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再强壮。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is trapped by the net.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被网住了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the net.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从网中脱离了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s blood turn into molten iron.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的血液变成了融化的铁水."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# no longer has molten iron blood.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的血液不再是融化的铁水."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is seared.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 烧焦了."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer seared.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再烧焦."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# tosses steamguns in the air, awesome!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 将蒸汽枪扔向天空，小心！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# somehow catches the falling steamguns.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 接住了蒸汽枪."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is marked!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被标记了!"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is very itching!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 非常痒!"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# regains their concentration.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 恢复了注意力."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is hiding in smoke.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 在烟雾中隐藏."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer hiding in smoke.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再隐藏于烟雾中."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is magnetised.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被磁化了."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the magnetism.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 从磁化中解脱."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is caught in the bloodstar.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被血液灵晶抓住了."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the bloodstar.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 从血液灵晶中解脱."):format(a)
	end,
}


logCHN:newLog{
	log = "#Target# is suffering and fails to concentrate on dealing damage.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 忍受痛苦，不能集中精力制造伤害."):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is suffering less.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再忍受折磨。"):format(a)
	end,
}
