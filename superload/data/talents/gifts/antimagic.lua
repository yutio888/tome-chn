local _M = loadPrevious(...)
local function combatTalentPhysicalMindDamage(self, t, b, s)
	return math.max(self:combatTalentMindDamage(t, b, s), self:combatTalentPhysicalDamage(t, b, s))
end
registerTalentTranslation{
	id = "T_RESOLVE",
	name = "分解",
	info = function(self, t)
		local resist = t.getResist(self, t)
		local regen = t.getRegen(self, t)
		return([[你选择了站在魔法的对立面。那些未能杀死你的磨难将使你更加强大。 
		每次你从敌对目标那里受到一种非物理、非精神时，你能增加 %d%% 对该类型伤害的抵抗，持续 7 回合。 
		在技能等级 3 时，你可以获得对 3 种类型的抵抗，每增加一种类型时都会刷新持续时间。
		此外  ，每当你被非物理，非精神伤害击中时，你会降低 %0.2f 失衡值并增加等量体力值。
		技能效果受精神或物理强度较高者加成。
		抗性加成效果可以触发精神暴击。]]):
		format(	resist, regen )
	end,
}

registerTalentTranslation{
	id = "T_AURA_OF_SILENCE",
	name = "反魔领域",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[发出一次音波冲击，沉默周围目标 %d 回合，有效范围 %d 码。 
		在 %d 回合内，受影响的区域里的所有生物受到 %0.2f 法力燃烧伤害。
		每沉默一个目标，你回复 %d 失衡值，至多 5 次。
		受精神或物理强度较高者影响，沉默几率有额外加成。
		
		学会这个技能，也会让你的自然伤害加成和伤害穿透属性，对所有法力燃烧伤害生效，不管这一伤害的来源是什么。]]):
		format(t.getduration(self,t), rad, t.getFloorDuration(self,t), t.getDamage(self, t), t.getEquiRegen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANTIMAGIC_SHIELD",
	name = "反魔法护盾",
	info = function(self, t)
		return ([[给你增加一个护盾，每次被攻击吸收最多 %d 点非物理、非精神元素伤害。  
		每吸收 30 点伤害都会增加 1 点失衡值，并进行一次失衡值鉴定，若鉴定失败，则护盾会破碎且技能会进入冷却状态。 
		受精神或物理强度较高者影响，护盾的最大伤害吸收值有额外加成。]]):
		format(t.getMax(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MANA_CLASH",
	name = "奥术对撞",
	info = function(self, t)
		local base = t.getDamage(self, t)
		local mana = base
		local vim = base / 2
		local positive = base / 4
		local negative = base / 4
		local is_adept = self:knowTalent(self.T_ANTIMAGIC_ADEPT) and "\n#GREEN#反魔专家:  #LAST#目标身上会被移除4个持续魔法技能。" or ""
		return ([[从目标身上吸收 %d 点法力， %d 点活力， %d 点正负能量，并触发一次链式反应，引发一次奥术对撞。 
		奥术对撞造成相当于 100%% 吸收的法力值或 200%% 吸收的活力值或 400%% 吸收的正负能量的伤害，按最高值计算（称为法力燃烧）。 
		受精神或物理强度较高者影响，效果有额外加成。
		%s]]):
		format(mana, vim, positive, is_adept)
	end,
}

registerTalentTranslation{
	id = "T_ANTIMAGIC_ADEPT",
	name = "反魔专家",
	info = function(self, t)
		return ([[你的奥术对撞技能还会从目标身上移除 4 个持续魔法技能。]]):
		format()
	end,
}
return _M
