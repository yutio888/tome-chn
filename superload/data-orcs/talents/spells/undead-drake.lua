local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAZE",
	name = "夷为平地",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你在死亡中狂欢，吞噬你受害者们的灵魂。每当你对一个目标造成伤害时，你造成 %0.2f 额外暗影伤害。
		除此之外，每当你杀死敌人时你获得 %d 个灵魂。
		伤害将会随你法术强度和心灵强度中较高者变化，且每回合最多触发十五次。 ]]):
		format(damDesc(self, DamageType.DARKNESS, damage), t.soulBonus(self,t))
	end,}

registerTalentTranslation{
	id = "T_INFECTIOUS_MIASMA",
	name = "疫毒瘴气",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[在目标区域释放一个致命的瘴气云团，对其中所有的目标造成 %0.2f 暗影伤害并有 20%% 几率使其感染一个持续 %d 回合的疾病。疾病将造成枯萎伤害并降低体质，力量，或敏捷。
		伤害将会随你法术强度和心灵强度中较高者变化。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), t.getBaneDur(self,t))
	end,}

registerTalentTranslation{
	id = "T_VAMPIRIC_SURGE",
	name = "吸血狂潮",
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)
		return ([[你激发一波吸血能量，持续 %d 回合。
		在状态持续中你造成的所有伤害的 %d%% 都将转换为你的生命。]]):
		format(dur, power)
	end,}


registerTalentTranslation{
	id = "T_NECROTIC_BREATH",
	name = "死灵吐息",
	info = function(self, t)
		return ([[你向半径 %d 的锥形内喷出致死瘴气。任何被喷到的目标将在 4  会合内受到 %0.2f 暗影伤害并被混乱灾祸或致盲灾祸影响。
		伤害将会随着你的魔力增长，并且暴击率基于你的魔法暴击率。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.DARKNESS, self:combatTalentStatDamage(t, "mag", 30, 550)))
	end,}
return _M