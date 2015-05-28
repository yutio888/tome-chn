local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SEARING_LIGHT",
	name = "灼热之矛",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local damageonspot = t.getDamageOnSpot(self, t)
		return ([[你 祈 祷 太 阳 之 力 形 成 1 个 灼 热 的 长 矛 造 成 %0.2f 点 伤 害 并 在 地 上 留 下 一 个 光 斑， 每 回 合 对 其 中 的 目 标 造 成 %0.2f 光 系 伤 害， 持 续 4 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHT, damage), damageonspot)
	end,
}

registerTalentTranslation{
	id = "T_SUN_FLARE",
	name = "日珥闪耀",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[祈 祷 太 阳 之 力， 在 %d 码 半 径 范 围 内 致 盲 目 标， 持 续 %d 回 合 并 照 亮 你 的 周 围 区 域（ 有 效 范 围 %d 码）。 
		 等 级 3 时 它 会 同 时 造 成 %0.2f 光 系 伤 害（ %d 码 有 效 范 围）。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(radius, duration, radius * 2, damDesc(self, DamageType.LIGHT, damage), radius)
   end,
}

registerTalentTranslation{
	id = "T_FIREBEAM",
	name = "阳炎喷射",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[汲 取 太 阳 之 力 向 目 标 射 出 一 束 太 阳 真 火， 对 一 条 直 线 的 敌 人 造 成 %0.2f 火 焰 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_SUNBURST",
	name = "日炎爆发",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 一 片 耀 眼 的 日 光， 对 你 周 围 的 敌 人 造 成 %0.2f 光 系 伤 害（ 有 效 半 径 %d 码）。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.LIGHT, damage), radius)
	end,
}

return _M
