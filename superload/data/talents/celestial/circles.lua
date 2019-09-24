local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CIRCLE_OF_SHIFTING_SHADOWS",
	name = "暗影之阵",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 的 脚 下 创 造 一 个 %d 码 半 径 范 围 的 阵 法， 它 会 提 高 你 %d 近 身 闪 避 和 所 有 豁 免 ， 并 对 周 围 目 标 造 成 %0.2f 暗 影 伤 害。 
		 阵 法 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。  ]]):
		format(radius, damage, (damDesc (self, DamageType.DARKNESS, damage)), duration)
	end,
}

registerTalentTranslation{
	id = "T_CIRCLE_OF_SANCTITY",
	name = "圣洁之阵",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[在 你 的 脚 下 制 造 一 个 %d 码 半 径 范 围 的 法 阵， 当 你 在 法 阵 内， 它 会 使 你 免 疫 沉 默 效 果 ， 沉 默 进 入 此 范 围 内 的 敌 人 ， 并 对 其 造 成  %d 光 系 伤 害 。
		 阵 法 持 续 %d 回 合。]]):
		format(radius, damDesc(self, DamageType.LIGHT, damage), duration)
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

registerTalentTranslation{
	id = "T_CELESTIAL_SURGE",
	name = "天体潮涌",
	info = function(self, t)
		return ([[从 你 的 法 阵 中 召 唤 天 体 能 量 的 潮 涌 。 任 何 站 在 你 的 法 阵 中 的 敌 人 将 会 被 减 速 %d%% ， 并 受 到 %d 光 系 和 %d 黑 暗 伤 害 。
		能 量 潮 涌 的 残 余 力 量 将 会 从 你 的 法 阵 中 发 出 。 在 %d 回 合 内 ， 你 每 站 在 一 个 法 阵 中 ， 都 会 获 得 额 外 的 天 体 能 量 恢 复。
		暗 影 之 阵 ： 获 得 +1 负 能 量 。
		圣 洁 之 阵 ： 获 得 +1 正 能 量 。
		守 护 之 阵 ： 获 得 +0.5 正 能 量 和 负 能 量 。]]):format(t.getSlow(self, t), damDesc(self, DamageType.LIGHT, t.getDamage(self, t)), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}

return _M
