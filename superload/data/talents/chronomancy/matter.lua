local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DUST_TO_DUST",
	name = "土归土",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[发射一道射线，令物质归于尘土，造成 %0.2f 时空与 %0.2f 物理伤害。
		也可以以自己为目标，制造一个围绕自己 %d 码的领域，在 3 回合内造成伤害。
		伤害受法术强度加成。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage / 2), damDesc(self, DamageType.PHYSICAL, damage / 2), radius)
	end,
}

registerTalentTranslation{
	id = "T_MATTER_WEAVING",
	name = "物质编织",
	info = function(self, t)
		local armor = t.getArmor(self, t)
		local immune = t.getImmunity(self, t) * 100
		return ([[你的血肉被改变，对伤害的抗性提高。
		增加 %d 护甲， %d%% 震慑与割伤免疫。
		护甲加成受魔法加成。]]):
		format(armor, immune)
	end,
}

registerTalentTranslation{
	id = "T_MATERIALIZE_BARRIER",
	name = "物质屏障",
	info = function(self, t)
		local length = t.getLength(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[制造一层坚实的物质墙，长度为 %d ，持续 %d 回合。
		当墙壁被挖掘时，会产生半径 %d 的爆炸，范围内敌人会进入流血状态， 6 回合内受到 %0.2f 物理伤害。]])
		:format(length, duration, radius, damDesc(self, DamageType.PHYSICAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_DISINTEGRATION",
	name = "裂解",
	info = function(self, t)
		local digs = t.getDigs(self, t)
		local chance = t.getChance(self, t)
		return ([[你造成物理和时空伤害时，有 %d%% 几率除去一项物理或魔法增益效果。
		每个生物每回合只能被除去一项效果。
		同时，你的土归土技能能挖至多 %d 格内的墙壁。]]):
		format(chance, digs)
	end,
}

return _M
