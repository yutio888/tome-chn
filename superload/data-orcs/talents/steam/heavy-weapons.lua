local _M = loadPrevious(...)


registerTalentTranslation{
	id = "T_HEAVY_WEAPONS",
	name = "重装武器",
	info = function(self, t)
		local nb = t.getNb(self,t)
		local flame = flamethrower_ammo(self)
		local flamecombat = table.clone(flame.combat, true)
		local fdmg = self:combatDamage(flamecombat)
		local fdamrange = flamecombat.damrange or 1.1
		local staffcombat = shockstaff(self)		
		local sdmg = self:combatDamage(staffcombat)
		local sdamrange = staffcombat.damrange or 1.1
		local snumb = t.getShockstaffNumb(self,t)
		local bolt = boltgun_ammo(self)
		local boltcombat = table.clone(bolt.combat, true)
		local bdmg = self:combatDamage(boltcombat)
		local bdamrange = boltcombat.damrange or 1.1
		local bsave = t.getBoltgunSaves(self,t)
		return([[你可以装备以下所示的三种重装武器，让你获得特殊的攻击能力。重装武器比普通蒸汽枪要强大得多，但需要重装武器弹药才能发射。你可以最多存储 %d 枚重装武器弹药，在没有装备重装武器的时候，每 3 回合装填 1 点弹药。
		#AQUAMARINE#喷火器#LAST#:向敌人发射液体火焰的燃烧装置。对半径 5 码范围内的目标，在 3 回合内造成 100%% 火焰武器伤害。喷火器忽略护甲，必定命中目标，并造成 %d 到 %d 的伤害。
		#AQUAMARINE#电击棒#LAST#:在近距离战斗中使用的带电的电棍。对正面所有敌人造成 100%% 闪电武器伤害，同时在 2 回合内减少他们造成的伤害 %d%% 。电击棒造成 %d 到 %d 的伤害，并且有很高的护甲穿透和暴击率。
		#AQUAMARINE#爆矢枪#LAST#:一种高速多管蒸汽枪，装载灌注了化学物质的子弹。射击两次造成 100%% 酸性伤害，并降低目标所有豁免 %d ，持续 5 回合。爆矢枪造成 %d 到 %d 的伤害，并且有很高的命中率和护甲穿透。
		你使用重装武器造成的伤害受灵巧值加成，他们受武器精通类技能加成的时候被视为蒸汽枪。]]):format(nb, fdmg, fdmg*fdamrange, snumb, sdmg, sdmg*sdamrange, bsave, bdmg, bdmg*bdamrange)
	end,
}

registerTalentTranslation{
	id = "T_HW_FLAMETHROWER",
	name = "喷火器",
	flamethrowerInfo = function(self, t)
		local ammo = flamethrower_ammo(self)
		local combat = table.clone(ammo.combat, true)
		local atk = self:combatAttack(combat)
		local dmg =  self:combatDamage(combat)
		local apr = self:combatAPR(combat)
		local damrange = combat.damrange or 1.1
		local crit = self:combatCrit(combat)
		
		local stat_desc = {}
		for stat, i in pairs(combat.dammod or {}) do
			local name = engine.interface.ActorStats.stats_def[stat].short_name:capitalize()
			stat_desc[#stat_desc+1] = ("%d%% %s"):format(i * 100, name)
		end
		stat_desc = table.concat(stat_desc, ", ")
		return ([[射程: 5
基础伤害: %d - %d
命中率: %d
护甲穿透: %d
暴击率: %+d%%
使用属性: %s]]):format(dmg, dmg*damrange, atk, apr, crit, stat_desc)
	end,
	info = function(self, t)
		return ([[你将你的蒸汽枪替换成一把强大的蒸汽动力的喷火器，将你的敌人化为灰烬。
		装备和取下喷火器不消耗时间。使用蒸汽枪射击会立刻取下喷火器。
		目前喷火器属性：

		%s]]):format(t.flamethrowerInfo(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FLAME_JET",
	name = "火焰喷射",
	info = function(self, t)
		return ([[发射一团火焰，在3回合内造成100%%火焰武器伤害。]])
		:format(dam)
	end,
}

registerTalentTranslation{
	id = "T_HW_SHOCKSTAFF",
	name = "电击棒",
	shockstaffInfo = function(self, t)
		local combat = shockstaff(self)
		local atk = self:combatAttack(combat)
		local dmg =  self:combatDamage(combat)
		local apr = self:combatAPR(combat)
		local damrange = combat.damrange or 1.1
		local crit = self:combatCrit(combat)
		
		local stat_desc = {}
		for stat, i in pairs(combat.dammod or {}) do
			local name = engine.interface.ActorStats.stats_def[stat].short_name:capitalize()
			stat_desc[#stat_desc+1] = ("%d%% %s"):format(i * 100, name)
		end
		stat_desc = table.concat(stat_desc, ", ")
		return ([[射程: 0
基础伤害: %d - %d
命中率: %d
护甲穿透: %d
暴击率: %+d%%
使用属性: %s]]):format(dmg, dmg*damrange, atk, apr, crit, stat_desc)
	end,
	info = function(self, t)
		return ([[你将你的蒸汽枪替换成一根通了强电的电棍，用于进行近战格斗。
		装备和取下电击棒不需要消耗时间。使用蒸汽枪射击会立刻取下电击棒。
		目前电击棒属性：

		%s]]):format(t.shockstaffInfo(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STORMSTRIKE",
	name = "暴风打击",
	info = function(self, t)
		return ([[挥舞电击棒，攻击正面所有敌人，造成 100%% 闪电武器伤害，降低他们所造成的伤害 %d%% ，持续 2 回合。
		当你装备电击棒时，这一技能取代普通近战攻击。
		你可以使用这一攻击冲向 5 码范围内的目标。]]):
		format(t.getNumb(self,t))
	end,
}

registerTalentTranslation{
	id = "T_HW_BOLTGUN",
	name = "爆矢枪",
	boltgunInfo = function(self, t)
		local ammo = boltgun_ammo(self)
		local combat = table.clone(ammo.combat, true)
		local atk = self:combatAttack(combat)
		local dmg =  self:combatDamage(combat)
		local apr = self:combatAPR(combat)
		local damrange = combat.damrange or 1.1
		local crit = self:combatCrit(combat)
		
		local stat_desc = {}
		for stat, i in pairs(combat.dammod or {}) do
			local name = engine.interface.ActorStats.stats_def[stat].short_name:capitalize()
			stat_desc[#stat_desc+1] = ("%d%% %s"):format(i * 100, name)
		end
		stat_desc = table.concat(stat_desc, ", ")
		return ([[射程: 10
基础伤害: %d - %d
命中率: %d
护甲穿透: %d
暴击率: %+d%%
使用属性: %s]]):format(dmg, dmg*damrange, atk, apr, crit, stat_desc)
	end,
	info = function(self, t)
		return ([[你把你的蒸汽枪替换成一把多管重型枪械，发射注入了致命的化学物质的子弹。
		装备和取下爆矢枪不消耗时间。使用蒸汽枪射击会立刻取下爆矢枪。
		目前爆矢枪属性：

%s]]):format(t.boltgunInfo(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FLECHETTE_BURST",
	name = "毒弹爆射",
	info = function(self, t)
		return ([[发射两枚化学毒弹，造成 100%% 武器伤害，降低所有豁免 %d ，持续 5 回合。]])
		:format(t.getSaves(self,t))
	end,
}

registerTalentTranslation{
	id = "T_HEAVY_WEAPON_EXPERTISE",
	name = "重装武器精通",
	info = function(self, t)
		local fdam = t.getFlameDamage(self,t)*100
		local flength = t.getFlameLength(self,t)
		local fdur = t.getFlameDuration(self,t)
		local fwalldam = t.getFireDamage(self,t)
		local fresist = t.getFireResist(self,t)
		local srad = t.getShockRadius(self,t)
		local sdam = t.getShockDamage(self,t)*100
		local sdur = t.getShockDuration(self,t)
		local srange = t.getShockRange(self,t)
		local adam = t.getBoltDamage(self,t)*100
		local arad = t.getAcidRadius(self,t)
		local adur = t.getAcidDuration(self,t)
		return ([[你通过特殊训练解锁了新的的重装武器战技。你现在可以消耗 1 重装武器弹药，根据你现在装备的重装武器类型，触发以下的效果。
#AQUAMARINE#喷火器#LAST#: 用喷火器扫射地面，造成 %d%% 火焰武器伤害，并产生一道长度为 %d 的火墙，持续 %d 回合。在火墙内的敌人会受到 %0.2f 的火焰伤害，且它们的火焰伤害抗性会降低 %d%% ，持续 2 回合。
#AQUAMARINE#电击棒#LAST#: 用电棒猛击目标，在 %d 码范围内产生冲击波，造成 %d%% 闪电武器伤害，并震慑敌人 %d 回合。如果敌人在近战范围外，你可以冲向 %d 码范围内的敌人。
#AQUAMARINE#爆矢枪#LAST#: 发射爆炸弹药，在 %d 码范围内造成 %d%% 酸性武器伤害，随机致盲或缴械里面的敌人，持续 %d 回合。
火墙和化学云雾造成的伤害，以及造成异常状态的几率，受蒸汽强度加成。]])
		:format(fdam, flength, fdur, fwalldam, fresist, srad, sdam, sdur, srange, arad, adam, adur)
	end,
}

registerTalentTranslation{
	id = "T_AUTOMATED_DEFENSES",
	name = "自动防御系统",
	info = function(self, t)
		local evade = t.getEvasion(self,t)
		local armor = t.getArmor(self,t)
		local chance = t.getChance(self,t)
		local heal = t.getHeal(self,t)
		local reduce = t.getEffectReduction(self,t)
		return([[你操纵重装武器的技巧让你可以基于当前重装武器的类型提升自己的防御能力。
#AQUAMARINE#喷火器#LAST#: 喷火器中喷出的浓烟阻碍了你敌人的视线，你有几率 %d%% 闪避近战和远程攻击。
#AQUAMARINE#电击棒#LAST#: 将自己包裹在一个闪电防护力场里，增加护甲 %d 。在你被临近格子的目标攻击的时候，有 %d%% 几率用 50%% 的电击棒伤害反击他们（每回合最多触发一次）。
#AQUAMARINE#爆矢枪#LAST#: 每当你发射爆矢枪的时候，它会往你的身体中注入有益的化学物质，恢复 %d 生命值，并降低一个随机物理负面效果持续时间 %d 回合。
护甲值和治疗量受蒸汽强度加成。]]):format(evade, armor, chance, heal, reduce)
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
#AQUAMARINE#电击棒#LAST#: 用电击棒重击地面，释放所有的电力，在 %d 码范围内造成 %d%% 闪电武器伤害。被击中的目标会被击退 %d 码，如果他们被击退到墙上，这会产生一个静电脉冲，在半径 1 码范围内造成 %0.2f 闪电伤害，并被眩晕 2 回合。
#AQUAMARINE#爆矢枪#LAST#: 超载你的爆矢枪，发射一枚致命的弹药，穿透一条直线造成 %d%% 武器伤害。被击中的目标身上每有一个物理或精神负面效果，就会额外受到 %d%% 伤害（最多 %d%% ），并且它们身上的负面效果的持续时间会增加 %d 回合。]]):
		format(frange, damDesc(self, DamageType.FIRE, fdam), fburn*100, srad, sdam*100, sknockback, damDesc(self, DamageType.LIGHTNING, spulse), bdam*100, binc, binc*5, bdur)
	end,
}


return _M