local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_SHED_SKIN",
	name = "蜕皮",
	info = function(self, t)
		return ([[你 蜕 去 表 层 变 异 皮 肤， 同 时 增 加 它 的 强 度， 令 其 在 7 回 合 内 吸 收 %d 伤 害 。]]):format(t.getAbsorb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PUSTULENT_GROWTH",
	name = "脓包生长",
	info = function(self, t)
		return ([[每 次 你 的 蜕 皮 护 盾 损 失 %d%% 护 盾 量 或 者 你 受 到 超 过 15%% 最 大 生 命 值 的 伤 害 时， 一 个 黑 色 的 腐 败 脓 包 将 在 你 身 上 生 长 5 回 合。
		每 个 脓 包 增 加 你 %d%% 全 体 伤 害 抗 性。
		你 最 多 能 同 时 拥 有 %d 个 脓 包。
		抗 性 受 法 术 强 度 加 成 。]]):
		format(t.getCutoff(self, t), t.getResist(self, t), t.getMax(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PUSTULENT_FULMINATION",
	name = "脓包爆裂",
	info = function(self, t)
		return ([[你 引 爆 身 上 所 有 脓 包， 产 生 黑 色 液 体 溅 射 到 半 径 %d 格 内 所 有 生 物上， 每 个 脓 包 造 成 %0.2f 暗 影 伤 害 并 治 疗 你 %0.1f 生命。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.DARKNESS, t.getDam(self, t)), t.getHeal(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DEFILED_BLOOD",
	name = "污血",
	info = function(self, t)
		return ([[每 次 脓 包 爆 裂 时， 你 会 在 地 上 留 下 一 滩 持 续 5 回 合 的 污 血 。
		范 围 内 的 敌 人 每 回 合 将 被 污 血 中 产 生 的 触 手 纠 缠， 受 到 %d%% 暗 影 触 手 伤 害 并 被 污 血 覆 盖 2 回 合 。
		被 污 血 覆 盖 的 敌 人 击 中 你 时 ， 你 受 到 %d%% 相 应 伤 害 的 治 疗。
		治 疗 系 数 受 法 术 强 度 影 响。]]):
		format(t.getDam(self, t) * 100, t.getHeal(self, t))
	end,
}

return _M
