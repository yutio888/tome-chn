local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TEMPORAL_HOUNDS",
	name = "时空猎犬",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		local cooldown = self:getTalentCooldown(t)
		local resists = t.getResists(self, t)
		return ([[召 唤 一 条 时 空 猎 犬 。
		 每 隔 %d 回 合 召 唤 另 一 条 时 空 猎 犬 ，直 至 最 多 3 条 。
		 当 一 条 猎 犬 死 去 时 ，你 将 在 %d 回 合 内 召 唤 一 条 新 的 猎 犬 。
		 你 猎 犬 继 承 你 的 伤 害 加 成 ，有 %d%% 物 理 和 %d%% 时 空 抗 性 ，对 传 送 效 果 免 疫 。
		 猎 犬 将 拥 有 %d  力 量 ， %d 敏 捷 ， %d 体 质 ， %d 魔 法 和 %d 灵 巧 ，基 于 你 的 魔 法 。]])
		:format(cooldown, cooldown, resists/2, math.min(100, resists*2), incStats.str + 1, incStats.dex + 1, incStats.con + 1, incStats.mag + 1, incStats.wil +1, incStats.cun + 1)
	end,
}

registerTalentTranslation{
	id = "T_COMMAND_BLINK",
	name = "闪烁命令",
	info = function(self, t)
		local defense = t.getDefense(self, t)
		return ([[命 令 你 的 时 空 猎 犬 传 送 至 指 定 位 置 。
		 如 果 你 指 定 敌 人 为 目 标 ，猎 犬 们 将 视 其 为 目 标 攻 击 。
		 当 你 学 会 该 技 能 后 ，你 的 猎 犬 在 传 送 后 获 得 %d 闪 避 和 %d 全 抗 。
		 技 能 等 级 5 时 ，若 猎 犬 数 小 于 最 大 召 唤 数 目 ，使 用 该 技 能 时 将 召 唤 一 条 新 猎 犬 。
		 传 送 加 成 受 法 术 强 度 加 成 。]]):format(defense, defense, defense/2, defense/2)
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_VIGOUR",
	name = "时空活力",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local regen = t.getRegen(self, t)
		local haste = t.getHaste(self, t) * 100
		local immunities = t.getImmunities(self, t) * 100
		return ([[你 的 猎 犬 现 在 在 生 命 值 降 至 1 以 下 后 还 能 生 存 至 多 %d 回 合 ，免 疫 所 有 伤 害 但 造 成 的 伤 害 减 少 50%% 。
		 闪 烁 命 令 将 能 让 猎 犬 每 回 合 回 复 %d  生 命 并 增 加 %d%%  整 体 速 度 ，持 续 5 回 合 。生 命 1 以 下 的 猎 犬 将 加 倍 该 效 果 。
		 当 你 学 会 该 技 能 后 ，你 的 猎 犬 获 得 %d%% 震 慑 致 盲 混 乱 定 身 免 疫 。
		 生 命 回 复 受 法 术 强 度 加 成 。]]):format(duration, regen, haste, immunities)
	end,
}

registerTalentTranslation{
	id = "T_COMMAND_BREATHE",
	name = "吐息命令",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local stat_damage = t.getDamageStat(self, t)
		local duration =t.getDuration(self, t)
		local affinity = t.getResists(self, t)
		return ([[命 令 猎 犬 们 使 用 时 光 吐 息 ，锥 形 范 围 半 径 %d 范 围 内 造 成 %0.2f 时 空 伤 害 并 减 少 目 标 三 项 最 高 属 性 值 %d 点 %d 回 合 。
		 你 免 疫 自 己 猎 犬 的 吐 息 。自 己 的 猎 犬 免 疫 其 他 猎 犬 的 属 性 降 低 效 果 。
		 当 你 学 会 该 技 能 后 ，猎 犬 们 获 得 %d%% 时 空 伤 害 吸 收 。]]):format(damDesc(self, DamageType.TEMPORAL, damage), radius, stat_damage, duration, affinity)
	end,
}

return _M
