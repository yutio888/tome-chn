local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FURNACE",
	name = "熔炉",
	info = function(self, t)
		local damageinc = t.getFireDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		return ([[你往蒸汽制造机中安装一个便携式熔炉。
		熔炉激活时，你的物理和火焰伤害增加 %d%% ，物理和火焰抗性穿透增加 %d%% 。
		#{italic}#用蒸汽烧尽一切！#{normal}#
		]]):
		format(damageinc, ressistpen)
	end,}

registerTalentTranslation{
	id = "T_MOLTEN_METAL",
	name = "融化金属",
	info = function(self, t)
		local reduction = 1
		local mp = self:hasEffect(self.EFF_FURNACE_MOLTEN_POINT)
		if mp then reduction = 0.75 ^ mp.stacks end
		return ([[你的护甲温度极高，能驱散部分能量攻击。
		所有非物理、非精神伤害降低 %d 点（当前 %d ）。
		每回合该效果触发时，你获得 1 点融化点数（最多 1 0 点），减少 25%% 减伤效率。
		奔跑和休息将取消融化点数。
		#{italic}#火热的液态金属，乐趣无穷！#{normal}#
		]]):format(t.getResist(self, t), t.getResist(self, t) * reduction)
	end,}


registerTalentTranslation{
	id = "T_FURNACE_VENT",
	name = "通风孔",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local mp = self:hasEffect(self.EFF_FURNACE_MOLTEN_POINT)
		local stacks = mp and mp.stacks or 0
		return ([[打开熔炉通风孔，制造锥形热风，在 1 0 点融化点数时造成最多 %0.2f 火焰伤害（当前 %0.2f 点）。
		消耗所有融化点数。
		#{italic}#让火焰净化一切！#{normal}#
		]]):
		format(damDesc(self, DamageType.FIRE, damage), damDesc(self, DamageType.FIRE, damage) * stacks / 10)
	end,}

registerTalentTranslation{
	id = "T_MELTING_POINT",
	name = "熔点",
	info = function(self, t)
		return ([[当你达到 1 0 点融化点数时，你的护甲过热，温度极高，以至于 %d 个负面物理状态被高温驱散。
		同时，一种特殊的药物注射器将注射一种火焰免疫药剂，令你免疫烧伤效果。
		该效果触发时，消耗所有融化点数，并自动触发一次通风孔效果，目标为最后一次提供融化点数的生物。 
		该效果将消耗 1 5 点蒸汽。蒸汽不足时不能触发。
		#{italic}#只是肉体在燃烧!#{normal}#
		]]):
		format(t.getNb(self, t))
	end,}
return _M