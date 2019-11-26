local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GRENADE_LAUNCHER",
	name = "榴弹发射器",
	info = function(self, t)
		local dam = t.getDamage(self,t)*100
		local rad = self:getTalentRadius(t)
		return ([[你在蒸汽枪上装在一个榴弹发射器，它可以发射高度爆炸性的弹药。每当你使用蒸汽枪射击的时候，你会朝目标发射一枚手榴弹，爆炸在 %d 码范围内造成 %d%% 蒸汽枪伤害。
		这一技能也会强化你的护甲，你的随从免疫你的手榴弹效果。
		你每 6 回合内最多发射一枚榴弹。]]):
		format(rad, dam)
	end,
}

registerTalentTranslation{
	id = "T_REACTIVE_ARMOR",
	name = "反应式装甲",
	info = function(self, t)
		local reduce = t.getReduction(self,t)
		local rad = self:getTalentRadius(t)
		local mult = t.getMult(self,t)		
		local cd = self:getTalentCooldown(t)
		return ([[你在你的护甲上嵌入爆炸物装甲层，在被攻击的时候会发生爆炸。在近战或远程攻击对你造成超过最大生命值 8%% 的伤害的时候，装甲层会发生爆炸，降低所受到的伤害 %d%% 并在目标方向 %d 码范围的扇形区域内触发一次手榴弹攻击，造成平常的手榴弹 %d%% 的伤害。
		每回合最多触发一次该效果。
		你最多同时能有 3 层护甲层，每 %d 回合会补充一层。]]):
		format(reduce, rad, mult, cd)
	end,
}

registerTalentTranslation{
	id = "T_SAPPER",
	name = "爆破工兵",
	info = function(self, t)
		local ipower=t.getFirePower(self,t)
		local cpower=t.getAcidPower(self,t)
		local spower=t.getLightningPower(self,t)
		return ([[你往你的发射器内装入高级榴弹。
		燃烧榴弹：在 3 回合内造成火焰伤害，增加所受到的伤害 %d%% 。
		化学榴弹：造成酸性伤害，减速目标 %d%% ，持续 3 回合。
		震荡榴弹：造成闪电伤害，震撼目标 %d 回合，使目标震慑和定身抗性减半。
		你只能同时激活一种榴弹类型，反应式装甲不会触发高级榴弹。]]):
		format(ipower, cpower, spower)
	end,
}

registerTalentTranslation{
	id = "T_BARRAGE",
	name = "榴弹轰炸",
	info = function(self, t)
		local nb = t.getNb(self,t)
		local speed = t.getSpeed(self,t)*100
		return ([[你往发射器中装入一组 %d 发榴弹，让你接下来的 %d 次射击时会从榴弹发射器中发射一枚随机类型的榴弹。
		当你装入榴弹后，你的攻击速度提高 %d%% 。
		你的榴弹发射器技能必须处于冷却状态才能使用该技能。装入的榴弹最多持续 6 回合，会在你装备重装武器的时候解除。]]):
		format(nb, nb, speed)
	end,
}

registerTalentTranslation{
	id = "T_INCENDIARY_GRENADE",
	name = "燃烧榴弹",
	info = function(self, t)
		return ([[用高度易燃物质强化榴弹，烧蚀敌人护甲，3回合内造成火焰伤害，在目标燃烧时增加所受到的伤害 %d%% 。]]):
		format(t.getEffect(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CHEMICAL_GRENADE",
	name = "化学榴弹",
	info = function(self, t)
		return ([[用致残化学物质强化榴弹，造成酸性伤害，降低目标整体速度 %d%% ，持续 6 回合。]]):
		format(t.getEffect(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHOCK_GRENADE",
	name = "震荡榴弹",
	info = function(self, t)
		return ([[用电力弹药强化榴弹，造成闪电伤害，震撼敌人 %d 回合，减半其震慑和定身抗性。]]):
		format(t.getEffect(self, t))
	end,
}

return _M