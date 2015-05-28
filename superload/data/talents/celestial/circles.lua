local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CIRCLE_OF_SHIFTING_SHADOWS",
	name = "暗影之阵",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 的 脚 下 创 造 一 个 %d 码 半 径 范 围 的 阵 法， 它 会 提 高 你 %d 近 身 闪 避 并 对 周 围 目 标 造 成 %0.2f 暗 影 伤 害。 
		 阵 法 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。  ]]):
		format(radius, damage, (damDesc (self, DamageType.DARKNESS, damage)), duration)
	end,
}

registerTalentTranslation{
	id = "T_CIRCLE_OF_BLAZING_LIGHT",
	name = "炽焰之阵",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 的 脚 下 制 造 一 个 %d 码 半 径 的 法 阵， 它 会 照 亮 范 围 区 域， 每 回 合 增 加 %d 正 能 量 并 造 成 %0.2f 光 系 伤 害 和 %0.2f 火 焰 伤 害。 
		 阵 法 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(radius, 1 + (damage / 4), (damDesc (self, DamageType.LIGHT, damage)), (damDesc (self, DamageType.FIRE, damage)), duration)
	end,
}

registerTalentTranslation{
	id = "T_CIRCLE_OF_SANCTITY",
	name = "圣洁之阵",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 的 脚 下 制 造 一 个 %d 码 半 径 范 围 的 法 阵， 当 你 在 法 阵 内， 它 会 使 你 免 疫 沉 默 效 果 并 沉 默 此 范 围 内 的 敌 人。 
		 阵 法 持 续 %d 回 合。]]):
		format(radius, duration)
	end,
}

registerTalentTranslation{
	id = "T_CIRCLE_OF_WARDING",
	name = "守护之阵",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 的 脚 下 制 造 一 个 %d 码 半 径 范 围 的 法 阵， 它 会 减 慢 %d%% 抛 射 物 速 度 并 将 除 你 外 的 其 他 生 物 推 出 去。 
		 同 时， 每 回 合 对 目 标 造 成 %0.2f 光 系 伤 害 和 %0.2f 暗 影 伤 害。 
		 法 阵 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(radius, damage*5, (damDesc (self, DamageType.LIGHT, damage)), (damDesc (self, DamageType.DARKNESS, damage)), duration)
	end,
}

return _M
