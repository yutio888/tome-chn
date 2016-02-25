local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GESTALT",
	name = "格式塔",
	info = function(self, t)
		return ([[你 让 你 的 心 灵 从 你 的 蒸 汽 发 动 机 中 汲 取 能 量， 按 照 你 蒸 汽 的 比 例 增 加 你 的 精 神 强 度： 满 蒸 汽 时 %d 点， 0 蒸 汽 时 0 点。
		使 用 精 神 技 能 会 反 馈 你 的 发 动 机， 为 你 的 下 一 个 蒸 汽 技 能 增 加 %d 点 蒸 汽 强 度。
		使 用 蒸 汽 技 能 会 反 馈 你 的 精 神， 增 加 你 的 %d 点 你 的 超 能 力。
		效 果 会 随 着 你 的 精 神 强 度 增 加。]]):
		format(t.getMind(self, t), t.getSteam(self, t), t.getPsi(self, t))
	end,}

registerTalentTranslation{
	id = "T_IMPROVED_GESTALT",
	name = "强化格式塔",
	info = function(self, t)
		local shield_power = t.getShieldPower(self, t)
		return ([[每 当 你 在 格 式 塔 激 活 状 态 中 使 用 蒸 汽 技 能 时， 你 会 吸 取 一 些 残 留 的 力 量	来 形 成 一 个 精 神 护 盾。
		这 个 护 盾 持 续 3 回 合， 并 能 吸 收 %d 伤 害。
		效 果 会 随 着 你 的 精 神 强 度 增 加。]]):format(shield_power)
	end,}

registerTalentTranslation{
	id = "T_INSTANT_CHANNELING",
	name = "瞬间引导",
	info = function(self, t)
		return ([[瞬 间 引 导 你 剩 余 的 所 有 蒸 汽 来 补 充 你 的 超 能 力 并 充 能 或 制 造 一 个 新 的 精 神 护 盾。
		护 盾 的 持 续 时 间 会 增 加 3 回 合， 并 能 多 吸 收 %d%% 消 耗 的 蒸 汽 数 额 的 伤 害。
		你 回 复 等 同 于 %d%% 所 消 耗 的 蒸 汽 数 额 的 超 能 力。
		此 技 能 需 要 格 式 塔 在 激 活 状 态 且 有 一 个 精 神 护 盾 或 者 强 化 格 式 塔 不 在 冷 却 中。]]):format(t.getPower(self, t), t.getPsi(self, t))
	end,}

registerTalentTranslation{
	id = "T_FORCED_GESTALT",
	name = "强力格式塔",
	info = function(self, t)
		return ([[暂 时 延 伸 你 的 心 灵 以 使 你 的 格 式 塔 笼 罩 你 周 围 半 径 5 码 内 的 敌 人， 最 多 可 影 响 %d 个 敌 人。
		格 式 塔 会 吸 收 每 个 被 影 响 敌 人 的 力 量 （物 理 强 度， 精 神 强 度， 法 术 强 度， 蒸 汽 强 度） %d 回 合。
		你 自 身 的 力 量 会 增 加 所 吸 取 的 数 额 （效 果 每 个 额 外 的 敌 人 都 会 衰 减）。
		除 此 之 外， 在 5 回 合 内 你 可 以 超 脱 视 线 的 感 知 半 径 %d 码 内 的 生 物。
		效 果 会 随 着 你 的 精 神 强 度 增 加。]]):format(t.getNb(self, t), t.getPower(self, t), t.getSenseRadius(self, t))
	end,}
return _M