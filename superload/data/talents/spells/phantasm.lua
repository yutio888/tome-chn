local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ILLUMINATE",
	name = "照明术",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local turn = t.getBlindPower(self, t)
		local dam = t.getDamage(self, t)
		return ([[制造一个发光的球体，照亮 %d 码半径范围区域。 
		在等级 3 时，它同时可以致盲看到它的人（施法者除外） %d 回合。 
		在等级 4 时，它会造成 %0.2f 点光系伤害。]]):
		format(radius, turn, damDesc(self, DamageType.LIGHT, dam))
	end,
}

registerTalentTranslation{
	id = "T_BLUR_SIGHT",
	name = "模糊视觉",
	info = function(self, t)
		local defence = t.getDefense(self, t)
		return ([[施法者的形象变的模糊不清，增加 %d 点闪避。 
		受法术强度影响，闪避有额外加成。]]):
		format(defence)
	end,
}

registerTalentTranslation{
	id = "T_PHANTASMAL_SHIELD",
	name = "幻象护盾",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[施法者被幻象护盾所包围，有10%%几率闪避武器攻击。若你受到近战打击，此护盾会对攻击者造成 %d 点光系伤害。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.LIGHT, damage))
	end,
}

registerTalentTranslation{
	id = "T_INVISIBILITY",
	name = "隐形",
	info = function(self, t)
		local invisi = t.getInvisibilityPower(self, t)
		return ([[施法者从视线中淡出，额外增加 %d 点隐形强度。 
		注意：你必须取下装备中的灯具，否则你仍然会被轻易发现。 
		由于你变的不可见，你脱离了相位现实。你的所有攻击降低 70%% 伤害。 
		当此技能激活时，它会持续消耗你的法力（ 2 法力 / 回合）。 
		受法术强度影响，隐形强度有额外加成。]]):
		format(invisi)
	end,
}


return _M
