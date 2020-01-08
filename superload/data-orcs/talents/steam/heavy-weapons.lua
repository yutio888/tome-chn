local _M = loadPrevious(...)


registerTalentTranslation{
	id = "T_HEAVY_WEAPONS",
	name = "重装武器",
	info = function(self, t)
		local nb = t.getNb(self,t)
		local fdam = t.getFlamethrowerBaseDamage(self,t)*100
		local sdam = t.getShockstaffBaseDamage(self,t)*100
		local snumb = t.getShockstaffNumb(self,t)
		local bdam = t.getBoltgunBaseDamage(self,t)*100
		local bsteam = t.getBoltgunSteam(self,t)
		return([[你可以装备以下所示的三种重装武器，让你获得特殊的攻击能力。重装武器比普通蒸汽枪要强大得多，但需要重装武器弹药才能发射。你可以最多存储 %d 枚重装武器弹药，在没有装备重装武器的时候，每 3 回合装填 1 点弹药。
		#AQUAMARINE#喷火器#LAST#:向敌人发射液体火焰的燃烧装置。对半径 5 码范围内的目标，在 3 回合内造成 %d%% 火焰蒸汽枪伤害。喷火器忽略护甲，必定命中目标，且会触发蒸汽枪的命中特效。
		#AQUAMARINE#电击棒#LAST#:在近距离战斗中使用的带电的电棍。对正面所有敌人造成 %d%% 闪电武器伤害，同时在 2 回合内减少他们造成的伤害 %d%% 。这一攻击被视为近战伤害，但可以触发弹药的命中效果。所有电击棒攻击也会附加同样闪电伤害的盾牌攻击。使用电击棒的时候，你可以冲刺攻击，冲刺的范围相当于你的蒸汽枪射程。
		#AQUAMARINE#爆矢枪#LAST#:一种高速多管蒸汽枪，装载灌注了化学物质的子弹。射击两次造成 %d%% 酸性伤害，每次命中获得 %d 蒸汽。
		你使用重装武器造成的伤害受灵巧值加成，他们受武器精通类技能加成的时候被视为蒸汽枪。
		使用蒸汽枪射击的时候，将会立刻解除装备你的重装武器。]]):
			format(nb, fdam, sdam, snumb, bdam, bsteam)
	end,
}

registerTalentTranslation{
	id = "T_HW_FLAMETHROWER",
	name = "喷火器",
	info = function(self, t)
		local hw = self:getTalentFromId(self.T_HEAVY_WEAPONS)
		local fdam = hw.getFlamethrowerBaseDamage(self, hw)*100
		return ([[你将你的蒸汽枪替换成一把强大的蒸汽动力的喷火器，将你的敌人化为灰烬。
		
		在 5 码范围内，在 3 回合内造成 %d%% 火焰蒸汽枪伤害。

		这一攻击必定命中目标，无视护甲。]]):format(fdam)
	end,
}

registerTalentTranslation{
	id = "T_FLAME_JET",
	name = "火焰喷射",
	info = function(self, t)
		local dam = t.getDamage(self,t)*100
		return ([[发射一团火焰，在 3 回合内造成 %d%% 火焰武器伤害。]])
		:format(dam)
	end,
}

registerTalentTranslation{
	id = "T_HW_SHOCKSTAFF",
	name = "电击棒",
	info = function(self, t)
		local hw = self:getTalentFromId(self.T_HEAVY_WEAPONS)
		local sdam = hw.getShockstaffBaseDamage(self, hw)*100
		local snumb = hw.getShockstaffNumb(self, hw)
		return ([[你将你的蒸汽枪替换成一根通了强电的电棍，用于进行近战格斗。
		
		在前方造成 %d%% 闪电蒸汽枪伤害，并降低他们所造成的伤害 %d%% ，持续 3 回合。这一效果视作近战攻击，但可以触发弹药的命中效果。所有电击棒伤害也会附加一次盾牌攻击，造成同样的闪电伤害。
		
		你可以冲刺进行电击棒攻击，冲刺范围等于蒸汽枪射程。]]):format(sdam, snumb)
	end,
}

registerTalentTranslation{
	id = "T_STORMSTRIKE",
	name = "暴风打击",
	info = function(self, t)
		return ([[挥舞电击棒，攻击正面所有敌人，造成 %d%% 闪电武器伤害，降低他们所造成的伤害 %d%% ，持续 3 回合。
		如果你装备了盾牌，你还会附加一次盾击。
		这一技能可以取代你的普通攻击]]):
		format(t.getDamage(self,t)*100, t.getNumb(self,t), self:getTalentRange(t))
	end,
}

registerTalentTranslation{
	id = "T_HW_BOLTGUN",
	name = "爆矢枪",
	info = function(self, t)
		local hw = self:getTalentFromId(self.T_HEAVY_WEAPONS)
		local bdam = hw.getBoltgunBaseDamage(self, hw)*100
		local bsteam = hw.getBoltgunSteam(self, hw)
		return ([[你把你的蒸汽枪替换成一把多管重型枪械，发射注入了致命的化学物质的子弹。
		
		每次攻击造成两次 %d%% 酸性武器伤害，击中恢复 %d 蒸汽]]):format(bdam, bsteam)
	end,
}

registerTalentTranslation{
	id = "T_FLECHETTE_BURST",
	name = "毒弹爆射",
	info = function(self, t)
		return ([[发射两枚化学毒弹，造成 %d%% 酸性武器伤害，每次击中恢复 %d 蒸汽。]])
		:format(t.getDamage(self,t)*100, t.getSteam(self,t))
	end,
}

registerTalentTranslation{
	id = "T_HEAVY_WEAPON_EXPERTISE",
	name = "重装武器精通",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local fdam = t.getFireDamage(self, t)
		local ftdam = t.getFlamethrowerDamage(self, t) * 100
		local fresist = t.getFireResist(self, t)
		local sdur = t.getShockDuration(self, t)
		local sdam = t.getShockstaffDamage(self, t) * 100
		local bdam = t.getBoltgunDamage(self, t) * 100
		local bcount = t.getBoltgunAttacks(self, t)
		-- local arad = t.getAcidRadius(self,t)
		return ([[你通过特殊训练解锁了新的的重装武器战技。你现在可以消耗 1 重装武器弹药，根据你现在装备的重装武器类型，触发以下的效果。
#AQUAMARINE#喷火器#LAST#: 用喷火器扫射地面，造成 %d%% 火焰蒸汽枪伤害，并产生一道长度为 7 的火墙，持续 5 回合。在火墙内的敌人会受到 %0.2f 的火焰伤害，且它们的火焰伤害抗性会降低 %d%% ，持续 2 回合。
#AQUAMARINE#电击棒#LAST#: 用电棒猛击目标，在 3 码范围内产生冲击波，造成 %d%% 闪电蒸汽枪伤害，并震慑敌人 %d 回合。
#AQUAMARINE#爆矢枪#LAST#: 发射 %d 枚爆炸弹药，造成 %d%% 酸性武器伤害，并缴械敌人 5 回合。
火墙造成的伤害，以及造成异常状态的几率，受蒸汽强度加成。]])
		:format(ftdam, fdam, fresist, sdam, sdur, bcount, bdam)
	end,
}

registerTalentTranslation{
	id = "T_AUTOMATED_DEFENSES",
	name = "自动防御系统",
	info = function(self, t)
		return([[你使用重装武器技术强化你的盾牌，在你装备重装武器的时候进行格挡，会触发以下的特殊效果。
#AQUAMARINE#喷火器#LAST#: 在火焰喷射器攻击半径范围内，释放出燃烧的呛人浓烟。被击中的敌人会受到 %d%% 火焰盾牌伤害，并被沉默 %d 回合。
#AQUAMARINE#电击棒#LAST#: 将盾牌注入闪电，攻击半径 3 码范围内的所有敌人，造成 %d%% 闪电盾牌伤害，并获得相当于最高伤害值 100%% 的伤害吸收护盾，持续 6 回合。
#AQUAMARINE#爆矢枪#LAST#: 从盾牌中发射出一团镖弹，攻击 7 码半径范围内的所有敌人，造成 %d%% 酸性盾牌伤害。目标身上会插满 %d 枚毒镖，持续 6 回合。被插毒镖的敌人受到近战或远程攻击的时候，毒镖会爆炸，造成相当于盾牌造成的伤害 50%% 的酸性伤害。
这些攻击不会触发反击效果。
沉默几率受蒸汽强度加成。]])
:format(t.getFlameDamage(self,t)*100, t.getSilenceDuration(self,t), t.getShockDamage(self,t)*100, t.getBoltDamage(self,t)*100, t.getBoltNb(self,t))
	end,
}

registerTalentTranslation{
	id = "T_SAFETY_OVERRIDE",
	name = "武器过载",
	info = function(self, t)
		local frange = t.getFlamethrowerRange(self,t)
		local fdam = t.getFlamethrowerDamage(self,t)
		local fburn = t.getFlamethrowerBurn(self,t)
		local sdam = t.getShockDamage(self,t)
		local srad = t.getShockRadius(self,t)
		local sknockback = t.getShockKnockback(self,t)
		local spulse = t.getShockPulseDamage(self,t)
		local bdam = t.getBoltDamage(self,t)
		local binc = t.getBoltDamageIncrease(self,t)
		local bdur = t.getBoltDuration(self,t)
		return ([[突破你重装武器的潜能，触发一个强大的效果。这会立刻使你停止使用重装武器，并消耗掉所有的弹药。
#AQUAMARINE#喷火器#LAST#: 引爆你的油箱，产生一场半径为 4 的爆炸，将你推到指定 %d 码内的某格内。被爆炸击中的敌人将会受到 %0.2f 火焰伤害，并且在不稳定的油料的助燃下，额外受到相当于当前燃烧伤害 %d%% 的伤害。
#AQUAMARINE#电击棒#LAST#: 用电击棒重击地面，释放所有的电力，在 %d 码范围内造成 %d%% 闪电电击棒伤害。被击中的目标会被击退 %d 码，如果他们被击退到墙上，这会产生一个静电脉冲，在半径 1 码范围内造成 %0.2f 闪电伤害，并被震慑 5 回合。
#AQUAMARINE#爆矢枪#LAST#: 超载你的爆矢枪，发射一枚致命的弹药，穿透一条直线造成 %d%% 蒸汽枪伤害。被击中的目标身上每有一个物理、魔法或精神负面效果，就会额外受到 %d%% 伤害（最多 %d%% ），并且它们身上的负面效果的持续时间会增加 %d 回合。]]):
		format(frange, damDesc(self, DamageType.FIRE, fdam), fburn*100, srad, sdam*100, sknockback, damDesc(self, DamageType.LIGHTNING, spulse), bdam*100, binc, binc*5, bdur)
	end,
}


return _M