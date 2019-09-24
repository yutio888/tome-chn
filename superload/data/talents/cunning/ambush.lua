local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHADOWGUARD",
	name = "暗影守卫",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local duration2 = t.getImmuneDuration(self, t)
		local spellpower = t.getSpellpower(self, t)
		local defence = t.getDefense(self, t)
		return ([[你融入暗影的能力，让你在潜行时获得25%%所有伤害抗性。
		当你的生命值降低到50%%以下时，你在%d回合内免疫负面状态，获得%d闪避和%d法术强度，持续%d回合]]):
		format(duration2, defence, spellpower, duration)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_GRASP",
	name = "影之抓握",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[你向目标伸出影之抓握，将其缴械并沉默%d回合。
		影子会对目标造成%d点暗影伤害，将它拉到你的身边。
		附加异常状态的几率受命中值影响，伤害受法术强度影响。]]):
		format(duration, damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_UMBRAL_AGILITY",
	name = "影之灵巧",
	info = function(self, t)
		return ([[你使用黑暗魔法来强化自己。
		你获得%d命中，%d闪避，%d%%暗影伤害穿透。
		加成效果法术强度影响。]])
		:format(t.getAccuracy(self, t), t.getDefense(self, t), t.getPenetration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_VEIL",
	name = "暗影面纱",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local res = t.getDamageRes(self, t)
		return ([[你融入阴影，并被其支配。
		触发该技能后的%d个回合内，你将会自动闪烁到一个附近的敌人身上（离第一个击中的目标距离在%d之内），攻击并造成%d%%暗影武器伤害。
		在融入阴影中时，你免疫所有异常状态，获得%d%%所有抗性。
		在此技能激活时，你不能控制你的角色，除非被杀死否则不会中断技能。
		如果找不到攻击的目标，技能将会自动中断。
		你的移动并不是传送。
		抗性提升效果受法术强度加成。]]):
		format(duration, t.getBlinkRange(self, t) ,100 * damage, res)
	end,
}




return _M
