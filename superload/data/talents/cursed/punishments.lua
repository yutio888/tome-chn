local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_REPROACH",
	name = "意念惩罚",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local spreadFactor = t.getSpreadFactor(self, t)
		return ([[你对任何敢于靠近的敌人释放意念惩罚，造成 %d 精神伤害。攻击可能会指向多个目标，但是每个目标会减少 %d%% 伤害。 
		25%% 概率附加思维封锁效果。受精神强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.MIND, damage), (1 - spreadFactor) * 100)
	end,
}

registerTalentTranslation{
	id = "T_HATEFUL_WHISPER",
	name = "憎恨私语",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local jumpRange = t.getJumpRange(self, t)
		local jumpCount = t.getJumpCount(self, t)
		local jumpChance = t.getJumpChance(self, t)
		local hateGain = t.getHateGain(self, t)
		return ([[你向周围的敌人发出充满憎恨的私语。第 1 个听到的敌人会受到 %d 点精神伤害并提供你 %d 仇恨值。在最初的 %d 回合里私语会从目标身上传播到 %0.1f 码半径范围新的敌人身上。 
		 每个目标在每回合有 %d%% 几率将私语传播向另一个目标。 
		25%% 概率附加思维封锁效果。 
		 受精神强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.MIND, damage), hateGain, jumpCount, jumpRange, jumpChance)
	end,
}

registerTalentTranslation{
	id = "T_AGONY",
	name = "极度痛苦",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local maxDamage = t.getDamage(self, t)
		local minDamage = maxDamage / duration
		return ([[对你的目标释放极大的痛苦。痛苦会在 %d 回合内逐渐增加。第一回合会造成 %d 点伤害并在最后 1 回合增加至 %d 点伤害（总计 %d ）。 
		25%% 概率附加思维封锁效果。 
		 受精神强度影响，伤害有额外加成。]]):format(duration, damDesc(self, DamageType.MIND, minDamage), damDesc(self, DamageType.MIND, maxDamage), maxDamage * (duration + 1) / 2)
	end,
}

registerTalentTranslation{
	id = "T_MADNESS",
	name = "精神崩溃",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local mindResistChange = t.getMindResistChange(self, t)
		return ([[每次你造成精神伤害时，有 %d%% 概率你的敌人必须用精神抵抗抵消你的精神强度，否则会崩溃。精神崩溃会使它们在短时间内被混乱、减速或震慑 3 回合，并且降低它们 %d%% 对精神伤害的抵抗。]]):format(chance, -mindResistChange)
	end,
}

return _M
