local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_PULSE_DETONATOR",
	name = "脉冲爆弹",
	info = function(self, t)
		return ([[向目标位置发射一发脉冲爆弹，当到达后爆炸形成范围 4 的锥形冲击波，对范围内敌人造成 %0.2f 物理伤害，击退 3 码并造成 %d 回合的眩晕。
		]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_FLYING_GRAPPLE",
	name = "飞爪擒拿",
	info = function(self, t)
		return ([[向目标发射一枚自动制导的蒸汽动力无人机。
		 命中目标后，无人机向 4 码内的所有方向发射金属飞爪。
		 飞爪会抓住范围内任何敌人，并将它们向目标拉扯。
		 如果拉扯过程中被其他生物阻挡，两者均受到 %0.2f 物理伤害。
		]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}


registerTalentTranslation{
	id = "T_NET_PROJECTOR",
	name = "束网弹射器",
	info = function(self, t)
		return ([[向目标发射一张范围 2 码的轻质电场束网，范围内的所有生物会被定身在原地，持续 5 回合。
		虽然电力不足以造成伤害，但是持续电击会导致肢体麻痹，全抗性降低 %d%% 。]]):
		format(t.getResist(self, t))
	end,}

registerTalentTranslation{
	id = "T_SAWFIELD",
	name = "飞锯领域",
	info = function(self, t)
		return ([[发射出大量的小型飞锯环绕目标飞行，范围 %d 码。 
		范围内的所有生物受到 %0.2f 物理流血伤害。
		技能持续 4 回合。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}
return _M