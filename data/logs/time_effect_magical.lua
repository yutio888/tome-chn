logCHN:newLog{
	log = "#Target# is weakened by the darkness!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被黑暗削弱！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# regains their energy.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了斗志。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is afflicted by a crippling illness!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被致残疾病感染！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the illness.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从疾病中解脱。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s armor corrodes!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的护甲被腐蚀了！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is fully armored again.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的护甲重新变得完整。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# starts to surge mana.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 开始快速回复法力。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# stops surging mana.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 停止快速回复法力。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# starts to overflow mana.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 法力溢出了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# stops overflowing mana.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 停止法力溢出。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# turns to stone!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被石化！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is not stoned anymore.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再石化。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# hardens its skin.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的皮肤变得坚硬。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s skin returns to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的皮肤恢复了正常状态。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s skin turns into molten lava.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的皮肤变成火山岩浆。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s skin starts to shimmer.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的皮肤开始闪光。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# vanishes from sight.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 从视线中消失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer invisible.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再隐形。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s eyes tingle.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的眼睛闪出光芒。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s eyes tingle no more.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的眼睛恢复了正常状态。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# wanders around!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 陷入昏迷而无目的地四处游荡！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# wanders around!.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 陷入昏迷而无目的地四处游荡！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# seems more focused.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 恢复了理智。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is overloaded with power.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的力量被超载。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# seems less dangerous.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的力量恢复了正常。"):format(a)
	end,
}

logCHN:newLog{
	log = "The very fabric of space alters around #target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的空间扭曲了。"):format(a)
	end,
}

logCHN:newLog{
	log = "A shield forms around #target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的空间恢复正常了。"):format(a)
	end,
}

logCHN:newLog{
	log = "A shield forms around #target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的周围产生了一道护盾。"):format(a)
	end,
}

logCHN:newLog{
	log = "The shield around #target# crumbles.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的护盾消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is a martyr.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 成为了一个殉道者。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer influenced by martyrdom.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再受殉难影响。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s aura dims.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的光环变得暗淡了。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# shines with renewed light.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 身边光明再次闪耀。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is cursed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被诅咒了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer cursed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再受诅咒。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is covered in acid!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被酸液覆盖！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the acid.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 身上的酸液消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is consumed in a burst of flame. All that remains is a fiery egg.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 化成了一道火光，留下了一个火红色的蛋。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# bursts out from the egg.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 从蛋中冲出。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is caught inside a Hurricane.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 卷入了飓风之中。"):format(a)
	end,
}

logCHN:newLog{
	log = "The Hurricane around #Target# dissipates.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 身边的飓风被驱散了。"):format(a)
	end,
}

logCHN:newLog{
	log = "You are yanked out of this place!",
	fct = function()
		return "你“呼”的一下被带离了这个地方！"
	end,
}

logCHN:newLog{
	log = "Space restabilizes around you.",
	fct = function()
		return "你周围的时空稳定了下来。"
	end,
}

logCHN:newLog{
	log = "#Target# casts a protective shield just in time!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s及时召唤出了一个保护护盾。"):format(a)
	end,
}

logCHN:newLog{
	log = "The protective shield of #Target# disappears.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的保护护盾消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is infected by a corrosive worm.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s感染了腐蚀蠕虫。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the corrosive worm.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了腐蚀蠕虫。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# turns into a wraith.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s变成了幽灵。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# returns to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了正常。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is returned to a much younger state!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s回到了幼儿时代。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has regained its natural age.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s回到了自然年龄。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is wasting away!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的时间被消耗！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# stops wasting away.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 停止了时间消耗。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has found the present moment!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s对当前的感知力提高了！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is invigorated.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s开始快速恢复体力。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer invigorated.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s停止快速恢复体力。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is gathering energy from other timelines.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从其他时间线吸取能量。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer manipulating the timestream.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s停止对时间线的操控。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is flawed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s出现弱点。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer flawed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再有弱点。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is infected by a manaworm!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s感染了法力蠕虫！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer infected.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再受到感染。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is engulfed in dark energies.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被黑暗能量包围。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# seems less powerful.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了正常。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# protected by flying bones.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s受到骨盾的保护。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# flying bones crumble.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再受到骨盾保护。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is unstable.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s变得不稳定。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# has regained stability.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了稳定。"):format(a)
	end,
}


logCHN:newLog{
	log = "#Target# is being removed from the timeline.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被从时间线中移除。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is doomed!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s遭受了厄运！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is freed from the impending doom.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了厄运。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# feels death coming!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s感受到了死亡迫近！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is freed from the rigor mortis.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了尸僵。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# feels closer to the abyss!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s堕入了深渊！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the abyss.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s逃离了深渊！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# takes fate by the hand.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 把握了自己的命运。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s fate is no longer being spun.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的命运不再受到掌控。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is afflicted by a rotting disease!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s受到腐化疫病的折磨！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the rotting disease.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了腐化疫病。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is afflicted by a decrepitude disease!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s受到了衰老疫病的折磨！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the decrepitude disease.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了衰老疫病。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is afflicted by a weakness disease!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s受到了虚弱疫病的折磨！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the weakness disease.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了虚弱疫病。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is afflicted by an epidemic!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s感染了传染病！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the epidemic.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了传染病。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is afflicted by a terrible worm rot!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s感染了腐肉虫！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the worm rot.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了腐肉虫。"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#A carrion worm mass bursts out of %s!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s处出现成熟的蠕虫!"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is afflicted by ghoul rot!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被食尸鬼的疾病感染!"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the ghoul rot.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了食尸鬼的疾病!"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is focused by an arcane vortex!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被奥术漩涡围绕。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is free from the arcane vortex.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s摆脱了奥术漩涡。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is surging with arcane energy.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s受到奥术能量强化。"):format(a)
	end,
}

logCHN:newLog{
	log = "#The arcane energy around Target# has dissipated.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s奥术能量消失。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# warded against %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s守护自己免受%s伤害。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#Target#'s %s ward fades",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s不再守护自己免受%s伤害。"):format(a,b)
	end,
}


logCHN:newLog{
	log = "There are creatures that could be watching you; you cannot take the risk of teleporting to Angolwen.",
	fct = function()
		return "有生物可以看见你，你不能冒这个险传送安格利文。"
	end,
}

logCHN:newLog{
	log = "#Target# starts to attract all creatures around!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s开始吸引周围的所有目标！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer attracting creatures.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再吸引周围的目标。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is surging arcane power.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s涌起了奥术能量。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer surging arcane power.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再涌起奥术能量。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is out of phase.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s脱离了相位空间。"):format(a)
	end,
}


logCHN:newLog{
	log = "#Target# is no longer out of phase.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s回到了正常空间。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is blood locked.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的鲜血受到禁锢。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer blood locked.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的鲜血不再受到禁锢。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# threads time as a shell!.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s扭曲了时间。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is no longer embeded in time.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再深入时间长河中。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# turns into a losgoroth!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s变成了罗斯戈洛斯。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# turns into a shivgoroth!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s变成了西弗戈洛斯。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer transformed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s恢复了原本的形态。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is covered in icy armor!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被冰甲覆盖！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s ice coating crumbles away.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的冰甲消散了。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is coated in acid!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被酸液覆盖！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s acid coating is diluted.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s覆盖的酸液消散了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is filled with the Sun's fury!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s充满了阳光的愤怒！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s solar fury subsides.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的阳光之怒消退了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is energized and protected by the Sun!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被阳光保护并充能。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is marked by light!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被光之印记标记。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s mark disappears.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s身上的光之印记消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# shines with light!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s身边光芒闪耀！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# stops shining.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再闪光。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# burns with light!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被光明灼烧！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# spins fate.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s编织命运！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# stops spining fate.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s停止编织命运！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# weaves fate.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s编织命运！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# stops weaving fate.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s停止编织命运！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is nearing the end.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s接近末日！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# has been tethered!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被时空锁链固定！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is no longer tethered.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再被时空锁链固定。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is anchored.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被禁止传送。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is no longer anchored.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再被禁止传送。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s lifeline has been braided.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的生命线被编织了。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target#'s lifeline is no longer braided.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的生命线不再被编织。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is no longer anchored.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再被禁止传送。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is no longer anchored.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再被禁止传送。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# has started to unravel.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s开始解体。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is caught in an entropic field!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被熵领域覆盖！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is free from the entropy.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从熵领域解脱。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# has regressed.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s退化了。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# has returned to its natural state.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s返回了自然状态。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is being being removed from the timeline!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被从时间线中除去！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# survived the attenuation.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s从时间线中存活了。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is being being grounded in the timeline!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被时间线围绕！"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# is no longer being grounded.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s不再被时间线围绕。"):format(a)
	end,
}
logCHN:newLog{
	log = "#Target# enters an ogric frenzy.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s进入狂热状态。"):format(a)
	end,
}
logCHN:newLog{
	log = "Spacetime has stabilized around #Target#.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s周围的时间线变得稳定"):format(a)
	end,
}
logCHN:newLog{
	log = "The fabric of spacetime around #Target# has returned to normal.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s周围的时间线恢复了正常。"):format(a)
	end,
}



logCHN:newLog{
	log = "#Target# is overflowing with dark power!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 充满了黑暗能量!"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target#'s dark aura fades.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的黑暗领域消退了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is fluctuating in time!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 在时光中波动!"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is no longer fluctuating.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不再波动。"):format(a)
	end,
}
