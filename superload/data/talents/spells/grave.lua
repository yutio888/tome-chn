local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CHILL_OF_THE_TOMB",
	name = "极寒坟墓",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[召 唤 1 个 冰 冷 的 球 体 射 向 目 标 并 产 生 死 亡 的 冰 冷 爆 炸 对 目 标 造 成 %0.2f 冰 冷 伤 害， 范 围 %d 码。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。
		 同 时，当 鬼 火 开 启 时 ， 被 这 个 法 术 杀 死 的 单 位 将 产 生 鬼 火。]]):
		format(damDesc(self, DamageType.COLD, damage), radius)
	end,
}

registerTalentTranslation{
	id = "T_WILL_O__THE_WISP",
	name = "鬼火",
	info = function(self, t)
		local chance, dam = t.getParams(self, t)
		return ([[亡 灵 的 能 量 缠 绕 着 你， 当 你 的 随 从 之 一 在 亡 灵 光 环 内 被 摧 毁 时， 它 有 %d%% 的 概 率 变 为 1 个 鬼 火。 
		 鬼 火 会 随 机 选 择 并 追 踪 目 标。 当 它 击 中 目 标 时， 它 会 爆 炸 并 造 成 %0.2f 冰 冷 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(chance, damDesc(self, DamageType.COLD, dam))
	end,
}

registerTalentTranslation{
	id = "T_COLD_FLAMES",
	name = "骨灵冷火",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local darkCount = t.getDarkCount(self, t)
		return ([[冰 冷 的 火 焰 从 目 标 点 向 %d 个 方 向 扩 散， 有 效 范 围 %d 码 半 径。 火 焰 会 造 成 %0.2f 冰 冷 伤 害 并 有 几 率 冰 冻 目 标。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(darkCount, radius, damDesc(self, DamageType.COLD, damage))
	end,
}

registerTalentTranslation{
	id = "T_VAMPIRIC_GIFT",
	name = "血族礼物",
	info = function(self, t)
		local chance, val = t.getParams(self, t)
		return ([[血 族 的 能 量 在 你 的 身 体 里 流 动； 每 次 你 对 目 标 造 成 伤 害 时 有 %d%% 概 率 吸 收 目 标 血 液， 恢 复 %d%% 伤 害 的 生 命 值。 
		 受 法 术 强 度 影 响， 吸 收 百 分 比 有 额 外 加 成。]]):
		format(chance, val)
	end,
}


return _M
