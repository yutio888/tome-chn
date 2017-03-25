local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GREATER_WEAPON_FOCUS",
	name = "专注打击",
	info = function(self, t)
		return ([[专 注 于 你 的 攻 击， 每 次 攻 击 有 %d%% 概 率 对 目 标 造 成 一 次 类 似 的 附 加 伤 害， 持 续 %d 回 合。 
		此 效 果 对 所 有 攻 击， 甚 至 是 技 能 攻 击 或 盾 击 都 有 效 果， 但 每 回 合 每 把 武 器 最 多 获 得 一 次 额 外 攻 击。 
		受 敏 捷 影 响， 概 率 有 额 外 加 成。]]):format(t.getchance(self, t), t.getdur(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STEP_UP",
	name = "步步为营",
	info = function(self, t)
		return ([[每 杀 死 1 个 敌 人 你 有 %d%% 概 率 增 加 1000%% 移 动 速 度， 持 续 一 个 标 准 游 戏 回 合。 
		此 效 果 在 你 执 行 除 移 动 外 其 他 动 作 后 立 刻 结 束。 
		注 意： 由 于 你 的 移 动 非 常 迅 速， 游 戏 回 合 会 过 的 很 慢。]]):format(math.min(100, self:getTalentLevelRaw(t) * 20))
	end,
}

registerTalentTranslation{
	id = "T_BLEEDING_EDGE",
	name = "撕裂鞭笞",
	info = function(self, t)
		local heal = t.healloss(self,t)
		return ([[割 裂 目 标 并 造 成 %d%% 武 器 伤 害。 
		如 果 攻 击 命 中 目 标， 则 目 标 会 持 续 流 血 7 回 合， 
		造 成 总 计 %d%% 武 器 伤 害。 在 此 过 程 中， 任 何 对 目 标 的 治 疗 效 果 减 少 %d%% 。]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.7), 100 * self:combatTalentWeaponDamage(t, 2, 3.2), heal)
	end,
}

registerTalentTranslation{
	id = "T_TRUE_GRIT",
	name = "刚毅",
	info = function(self, t)
		local drain = t.getStaminaDrain(self, t)
		local resistC = t.resistCoeff(self, t)
		return ([[采 取 一 个 防 守 姿 态 并 抵 抗 敌 人 的 猛 攻.
		当 你 受 伤 后 ， 你 获 得 相 当 于 %d%% 损 失 生 命 值 百 分 比 的 全 体 伤 害 抗 性。
		例 如：当你 损 失 70%% 生 命 时 获 得 %d%% 抗 性。
		同 时，你 的 全 体 伤 害 抗 性 上 限 相 比 于 100%% 差 距 将 减 少 %0.1f%% 。
		该 技 能 消 耗 体 力 迅 速，体 力 值 基 础 消 耗 %d ，每 回 合 增 加 0.3 。
		效 果 在 每 回 合 开 始 时 刷 新。]]):
		format(resistC, resistC*0.7, t.getCapApproach(self, t)*100, drain)
	end,
}


return _M
