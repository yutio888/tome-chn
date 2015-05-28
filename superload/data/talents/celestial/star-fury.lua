local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MOONLIGHT_RAY",
	name = "月光射线",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 月 光 的 力 量 形 成 阴 影 射 线， 对 目 标 造 成 %0.2f 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_BLAST",
	name = "阴影爆炸",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local damageonspot = t.getDamageOnSpot(self, t)
		local duration = t.getDuration(self, t)
		return ([[引 起 一 片 暗 影 爆 炸， 对 目 标 造 成 %0.2f 点 暗 影 伤 害， 并 在 3 码 半 径 范 围 的 区 域 内 每 回 合 造 成 %0.2f 暗 影 伤 害， 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage),damDesc(self, DamageType.DARKNESS, damageonspot),duration)
	end,
}

registerTalentTranslation{
	id = "T_TWILIGHT_SURGE",
	name = "光暗狂潮",
	info = function(self, t)
		local lightdam = t.getLightDamage(self, t)
		local darknessdam = t.getDarknessDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[一 股 汹 涌 的 光 暗 狂 潮 围 绕 着 你， 在 你 周 围 %d 码 半 径 内 造 成 %0.2f 光 系 和 %0.2f 暗 影 范 围 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.LIGHT, lightdam), damDesc(self, DamageType.DARKNESS, darknessdam))
	end,
}

registerTalentTranslation{
	id = "T_STARFALL",
	name = "星沉地动",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[你 摇 落 星 辰， 震 慑 %d 码 半 径 范 围 内 所 有 目 标 4 回 合， 并 造 成 %0.2f 暗 影 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.DARKNESS, damage))
	end,
}

return _M
