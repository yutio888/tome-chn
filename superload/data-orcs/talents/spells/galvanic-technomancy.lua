local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GALVANIC_ROD",
	name = "放电柱",
	info = function(self, t)
		local damage = t.getDamage(self, t) / 2
		local radius = self:getTalentRadius(t)
		return ([[你在指定位置召唤放电柱。放电柱会在 %d 码半径范围内释放电击，对所有生物造成 %0.2f 放电（火焰和闪电）伤害。
		你有 3 枚放电柱，它们各自有 %d 回合的冷却时间。
		这一技能可以触发无尽之炎效果。
		这一法术有 25%% 的几率触发风暴之怒。
		技能伤害受法术强度加成。]]):format(radius, damDesc(self, DamageType.FIRE, damage) + damDesc(self, DamageType.LIGHTNING, damage), self:getTalentCooldown(t))
	end,
}

registerTalentTranslation{
	id = "T_GALVANIC_ARCING",
	name = "电弧放射",
	info = function(self, t)
		local damage = t.getDamage(self, t) / 2
		return ([[你使用奥术能量来让放电柱额外停留 %d 回合。停留的放电柱不会活动，但是可以和其他放电柱建立链接。
		如果在 %d 码范围内有两枚放电柱，它们会链接起来，形成一条放电射线。
		如果在 %d 码范围内有三枚放电柱，它们会链接起来，形成一个三角形的放电领域。
		任何被放电射线或放电领域击中的生物都会每回合受到 %0.2f 放电伤害。
		你最多同时释放三枚放电柱。
		技能等级 3 时，所有被影响的生物会被震撼，使他们的震慑和定身抗性减半。
		技能等级 5 时，你的金属武器，或是装载了金属插件的武器，可以作为一个放电柱使用，该放电柱不计入你的放电柱总量。
		这一法术有 15%% 的几率触发风暴之怒。
		技能伤害受法术强度加成。]]):format(t.getDur(self, t), self:getTalentRange(t), self:getTalentRange(t), damDesc(self, DamageType.FIRE, damage) + damDesc(self, DamageType.LIGHTNING, damage))
	end,
}

registerTalentTranslation{
	id = "T_UNSTABLE_BLAST",
	name = "不稳定爆破",
	info = function(self, t)
		local damage = t.getDamage(self, t) / 2
		local radius = self:getTalentRadius(t)
		return ([[你召唤以太的能量，暂时使一枚放电柱的控制系统不稳定化。（你不能把自己武器作为的放电柱当做该技能的释放目标）
		这将会在 1 码半径内，或是在链接到的所有放电柱的领域内，产生一股冲击波。对所有生物造成 %0.2f 放电伤害，并震慑它们 %d 回合。
		这一法术可以触发无尽之炎效果。
		技能伤害受法术强度加成。]]):format(damDesc(self, DamageType.FIRE, damage) + damDesc(self, DamageType.LIGHTNING, damage), t.getDur(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ENERGY_MASS_CONVERSION",
	name = "质能转换",
	info = function(self, t)
		return ([[你使用大量的奥术能量，在你的放电柱中造成一股超载的不稳定爆破。
		额外的能量将会被转化成巨大的质量，将在任何放电柱 %d 码范围内所有的生物（不包括你）拖向放电领域的中央。
		只能在激活了一个三角放电领域的时候才可以使用。]])
		:format(self:getTalentRadius(t))
	end,
}

return _M