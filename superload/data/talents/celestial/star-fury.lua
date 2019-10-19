local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MOONLIGHT_RAY",
	name = "月光射线",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召唤月光的力量形成阴影射线，对目标造成 %0.2f 伤害。 
		 受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_BLAST",
	name = "阴影爆炸",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[引起一片暗影爆炸，对目标造成 %0.2f 点暗影伤害，并在 3 码半径范围的区域内每回合造成 %0.2f 暗影伤害，持续 %d 回合。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage),damDesc(self, DamageType.DARKNESS, damage/2),duration)
	end,
}

registerTalentTranslation{
	id = "T_TWILIGHT_SURGE",
	name = "光暗狂潮",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[一股汹涌的光暗狂潮围绕着你，在你周围 %d 码半径内造成 %0.2f 光系和 %0.2f 暗影范围伤害。 
		 受法术强度影响，伤害有额外加成。]]):
		 format(radius, damDesc(self, DamageType.LIGHT, dam),damDesc(self, DamageType.DARKNESS, dam))
	end,
}

registerTalentTranslation{
	id = "T_STARFALL",
	name = "星沉地动",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[你摇落星辰，震慑 %d 码半径范围内所有目标 4 回合，并造成 %0.2f 暗影伤害。 
		 受法术强度影响，伤害有额外加成。]]):
		format(radius, damDesc(self, DamageType.DARKNESS, damage))
	end,
}

return _M
