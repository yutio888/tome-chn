local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHADOWGUARD",
	name = "暗影守护 ",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local duration2 = t.getImmuneDuration(self, t)
		local spellpower = t.getSpellpower(self, t)
		local defence = t.getDefense(self, t)
		return ([[你的黑暗亲和技能，让你在离开潜行时获得 25%% 所有伤害抗性。
		此外，当你的生命值降低到 50%% 以下时，你在 %d 回合内免疫负面状态，并获得 %d 闪避和 %d 法术强度，持续 %d 回合。]]):
		format(duration2, defence, spellpower, duration)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_GRASP",
	name = "影之抓握",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[你向目标伸出影之抓握，将其缴械并沉默 %d 回合。
		影子会对目标造成 %d 点暗影伤害，将它拉到你的身边。
		技能伤害受法术强度加成。
		异常状态命中率受命中影响。]]):
		format(duration, damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_UMBRAL_AGILITY",
	name = "影之灵巧",
	info = function(self, t)
		return ([[你对暗影魔法的掌握使你更加强大。
		获得 %d 命中， %d 闪避， %d%% 暗影伤害抗性穿透。
		加成效果受法术强度影响。]])
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
		使用该技能时以及接下来的 %d 个回合内，你将会自动闪烁到一个附近的敌人身边（离第一个击中的目标的位置在 %d 码之内），攻击并造成 %d%% 暗影武器伤害。
		融入阴影时，你免疫所有异常状态，并获得 %d%% 全体伤害抗性。
		在此技能激活时，你无法控制你的角色，并且无法主动中断技能，直到死亡、持续时间结束、或者找不到攻击的目标。
		这个技能不视为传送。
		抗性提升效果受法术强度加成。]]):
		format(duration, t.getBlinkRange(self, t) ,100 * damage, res)
	end,
}




return _M
