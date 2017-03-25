local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RECLAIM",
	name = "沙化",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[ 你 将 自 然 无 情 的 力 量 集 中 于 某 个 目 标 上 ， 腐 蚀 他 并 让 他 重 归 生 命 轮 回。
		 造 成 %0.1f 点 自 然 伤 害 ， %0.1f 点 酸 性 伤 害 ， 对 不 死 族 和 构 装 生 物 有 %d%% 伤 害 加 成 。
		 受 精 神 强 度 影 响 ， 伤 害 有 额 外 加 成 。]]):
		format(damDesc(self, DamageType.NATURE, dam/2), damDesc(self, DamageType.ACID, dam/2), t.undeadBonus)
	end,
}

registerTalentTranslation{
	id = "T_NATURE_S_DEFIANCE",
	name = "自然的反抗",
	info = function(self, t)
		local p = t.getPower(self, t)
		return ([[ 你 对 自 然 的 贡 献 让 你 的 身 体 更 亲 近 自 然 世 界 ， 对 非 自 然 力 量 也 更 具 抵 抗 力。
		 你 获 得 %d 点 法 术 豁 免 ， %0.1f%% 奥 术 抗 性 ， 同 时 将 受 到 的 %0.1f%% 的 自 然 伤 害 转 化 为 治 疗。
		 由 于 你 和 奥 术 力 量 对 抗 ， 每 次 你 受 到 法 术 伤 害 时 ， 你 回 复 %0.1f 点 失 衡 值 ， 持 续 %d 回 合 。
		 受 精 神 强 度 影 响 ， 效 果 有 额 外 加 成 。]]):
		format(t.getSave(self, t), t.getResist(self, t), t.getAffinity(self, t), t.getPower(self, t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ACIDFIRE",
	name = "酸火",
	info = function(self, t)
		return ([[ 你 召 唤 酸 云 覆 盖 半 径 %d 的 地 面 ， 持 续 %d 回 合 。 酸 云 具 有 腐 蚀 性 ， 能 致 盲 敌 人 。
		 每 回 合 ， 酸 云 对 每 个 敌 人 造 成 %0.1f 点 酸 性 伤 害 ，25%% 几 率 致 盲， 同 时 有 %d%% 几 率 除 去 一 个 有 益 的 魔 法 效 果。
		 受 精 神 强 度 影 响 ， 伤 害 有 额 外 加 成。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t), damDesc(self, DamageType.ACID, t.getDamage(self, t)), t.getChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_EYAL_S_WRATH",
	name = "埃亚尔之怒",
	info = function(self, t)
		local drain = t.getDrain(self, t)
		return ([[  你 在 自 己 周 围 半 径 %d 的 范 围 内 制 造 自 然 力 量 风 暴 ， 持 续 %d 回 合 。
		 风 暴 会 跟 随 你 移 动 ， 每 回 合 对 每 个 敌 人 造 成 %0.1f 点 自 然 伤 害 ， 并 抽 取 %d 点 法 力 ， %d 点 活 力 ， %d 点 正 负 能 量 。
		 同 时 你 的 失 衡 值 会 回 复 你 抽 取 能 量 的 10%% 。
		 受 精 神 强 度 影 响 ， 伤 害 和 吸 取 量 有 额 外 加 成 。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t), damDesc(self, DamageType.NATURE, t.getDamage(self, t)), drain, drain/2, drain/4, drain/4)
	end,
}


return _M
