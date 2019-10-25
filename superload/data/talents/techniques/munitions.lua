local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_EXOTIC_MUNITIONS",
	name = "异种弹药",
	info = function (self,t)
		return ([[你学会了制造和装备专门的弹药:
燃烧弹- 命中后，对目标附近的敌人造成 %d%% 火焰武器伤害，范围最大为 %d ，每回合最多一次。
剧毒弹- 命中后，对目标造成 %0.2f 自然伤害并感染麻木毒素 , 在 5 回合内造成 %0.2f 自然伤害并削弱其 %d%% 的伤害。
穿甲弹- 命中后，使目标的护甲和豁免减少 %d ，持续 3 回合, 你的物理穿透增加 %d%% 。
同时只能装备一种弹药。
毒素伤害、护甲和豁免削减受物理强度加成。]]):
		format(t.getIncendiaryDamage(self, t)*100, t.getIncendiaryRadius(self,t), damDesc(self, DamageType.NATURE, t.getPoisonDamage(self, t)/5), damDesc(self, DamageType.NATURE, t.getPoisonDamage(self, t)), t.getNumb(self, t), t.getArmorSaveReduction(self, t), t.getResistPenalty(self,t))
	end,
}
registerTalentTranslation{
	id = "T_INCENDIARY_AMMUNITION",
	name = "燃烧弹",
	info = function (self,t)
		local damage = t.getIncendiaryDamage(self, t)*100
		local radius = self:getTalentRadius(t)
		return ([[装填燃烧弹, 对目标附近的敌人造成 %d%% 火焰武器伤害，范围最大为 %d 。
		该技能每回合最多触发一次.
		伤害受物理强度加成。]]):format(damage, radius)
	end,
}
registerTalentTranslation{
	id = "T_VENOMOUS_AMMUNITION",
	name = "剧毒弹",
	info = function (self,t)
		local damage = t.getPoisonDamage(self, t)
		local numb = t.getNumb(self,t)
		return ([[装填毒弹, 对目标造成 %0.2f 自然伤害并感染麻木毒素 , 在 5 回合内造成 %0.2f 自然伤害并削弱其 %d%% 的伤害。
		伤害随物理强度增加.]]):format(damDesc(self, DamageType.NATURE, damage/5), damDesc(self, DamageType.NATURE, damage), numb)
	end,
}
registerTalentTranslation{
	id = "T_PIERCING_AMMUNITION",
	name = "穿甲弹",
	info = function (self,t)
		local reduce = t.getArmorSaveReduction(self, t)
		local resist = t.getResistPenalty(self,t)
		return ([[装填穿甲弹, 使目标的护甲和豁免减少 %d 持续 3 回合, 你的物理穿透增加 %d%% 。
		护甲和豁免削减随物理强度增加.]]):format(reduce, resist)
	end,
}
registerTalentTranslation{
	id = "T_EXPLOSIVE_SHOT",
	name = "爆炸射击",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local radius = self:getTalentRadius(t)
		local dur = t.getDuration(self,t)
		local slow = t.getSlow(self,t)
		local fire = t.getFireResist(self,t)
		local poison = t.getPoisonDamage(self,t)
		local fail = t.getPoisonFailure(self,t)
		local nb = t.getRemoveCount(self,t)
		return ([[根据当前装填的弹药进行一次特殊的射击
燃烧弹- %d%% 火焰武器伤害，伤害半径 %d 。用粘稠的沥青包裹敌人 %d 回合, 减少 %d%% 整体速度并增加其受到的火焰伤害 %d%% 。
剧毒弹- %d%% 自然武器伤害。爆炸会形成半径 %d 的致残毒气云，持续 %d 回合, 每回合造成 %0.2f 自然伤害并使目标使用技能有 %d%% 几率失败。
穿甲弹- %d%% 物理武器伤害，伤害半径 %d ，并移除有益的物理效果或持续技能。
毒素伤害受物理强度加成, 状态触发几率受命中加成。]]):
		format(dam, radius, dur, slow, fire, dam, radius, dur, damDesc(self, DamageType.NATURE, poison), fail,  dam,radius, nb)
	end,
}
registerTalentTranslation{
	id = "T_ENHANCED_MUNITIONS",
	name = "强化弹药",
	info = function (self,t)
		local fire = t.getFireDamage(self,t)
		local poison = t.getPoisonDamage(self,t)
		local resist = t.getResistPenalty(self,t)
		return ([[你制造出强化版弹药, 获得额外效果：
燃烧弹- 爆炸范围增加 1, 点燃地面每回合额外造成 %0.2f 火焰伤害持续 3 回合.
剧毒弹- 感染水蛭毒素, 3 回合内造成 %0.2f 毒素伤害 , 毒素造成的 100%% 伤害会治疗你.
穿甲弹- 击穿目标护甲, 目标受到的所有伤害增加 %d%% 持续 3 回合.
你的强化版弹药有限, 所以技能有冷却时间.
伤害受物理强度加成, 状态触发几率受命中加成。]]):
		format(damDesc(self, DamageType.FIRE, fire), damDesc(self, DamageType.NATURE, poison), resist)
	end,
}
registerTalentTranslation{
	id = "T_ALLOYED_MUNITIONS",
	name = "合金弹头",
	info = function (self,t)
		local poison = t.getPoisonDamage(self,t)*100
		local radius = t.getPoisonRadius(self,t)
		local bleed = t.getPhysicalDamage(self,t)
		local numb = t.getNumb(self,t)
		local armor = t.getArmorSaveReduction(self,t)
		local resist = t.getResistPenalty(self,t)
		return ([[混合你的弹药, 造成更强力的效果:
燃烧弹- 受到爆炸袭击的目标护甲和豁免减少 %d 持续 3 回合, 你的物理和火焰穿透增加 %d%%.
剧毒弹- 造成 %d%% 自然武器伤害，伤害半径 %d , 并施加麻木毒素效果. 每回合最多生效一次.
穿甲弹- 造成 %0.2f 物理伤害并使目标流血, 5 回合内造成 %0.2f 物理伤害并减少他们造成的伤害 %d%%.
物理伤害、护甲和豁免削减受物理强度加成。]]):
		format(armor, resist, poison, radius, bleed/5, bleed, numb)
	end,
}
return _M
