local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SEARING_LIGHT",
	name = "灼热之矛",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local damageonspot = t.getDamageOnSpot(self, t)
		return ([[你 祈 祷 太 阳 之 力 形 成 1 个 灼 热 的 长 矛 造 成 %d 点 伤 害 并 在 地 上 留 下 一 个 光 斑， 每 回 合 对 其 中 的 目 标 造 成 %d 光 系 伤 害， 持 续 4 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHT, damage), damDesc(self, DamageType.LIGHT, damageonspot))
	end,
}

registerTalentTranslation{
	id = "T_SUN_FLARE",
	name = "日珥闪耀",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local res = t.getRes(self, t)
		local resdur = t.getResDuration(self, t)
		return ([[祈 祷 太 阳 之 力， 在 %d 码 半 径 范 围 内 致 盲 目 标， 持 续 %d 回 合 并 照 亮 你 的 周 围 区 域。
		范 围 内 的 敌 人 将 会 受 到 %0.2f 光 系 伤 害。
		等 级 3 时， 你 将 获 得 %d%% 光 系 、 暗 影 和 火 焰 伤 害 抗 性 ，  持 续 %d 回 合。
		受 法 术 强 度 影 响 ， 伤 害 和 抗 性 有 额 外 加 成 。]]):
		format(radius, duration, damDesc(self, DamageType.LIGHT, damage), res, resdur )

   end,
}

registerTalentTranslation{
	id = "T_FIREBEAM",
	name = "阳炎喷射",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[汲 取 太 阳 之 力 向 目 标 射 出 一 束 太 阳 真 火，射向最远的敌人，对这条 直 线上的所有 敌 人 造 成 %0.2f 火 焰 伤 害。 
		这 一 技 能 将 会 每 隔 一 个 回 合 自 动 额 外 触 发 一 次 ， 共 额 外 触 发 2 次 。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_SUNBURST",
	name = "日炎爆发",
	info = function(self, t)
		return ([[射 出 一 团 猛 烈 的 日 光 ， 你 的 光 系 伤 害 加 成 将 会 增 加 你 暗 影 伤 害 加 成 的 %d%% ，持 续 %d 回 合 ， 并 对 半 径 %d 内 最 多 %d 个 敌 人 造 成 %0.2f 点 光 系 伤 害。]]):
			format(t.getPower(self, t)*100, t.getDuration(self, t), self:getTalentRadius(t), t.getTargetCount(self, t), damDesc(self, DamageType.LIGHT, t.getDamage(self, t)))
	end,
}

return _M
