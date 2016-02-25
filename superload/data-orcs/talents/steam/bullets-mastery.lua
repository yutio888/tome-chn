local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_OVERHEAT_BULLETS",
	name = "过热子弹",
	info = function(self, t)
		return ([[使 用 蒸 汽 进 行 子 弹 的 过 热 处 理 。
		接 下 来 的 %d 回 合 内 ， 你 的 子 弹 会 点 燃 目 标 ， 在 5 回 合 内 造 成 %0.2f 火 焰 伤 害（ 大 多 数 射 击 技 能 一 次 发 射 两 枚 弹 药 ）。
		一 次 只 能 使 用 一 种 弹 药 强 化 能 力 。]]):
		format(t.getTurns(self, t), damDesc(self, DamageType.FIRE, t.getDam(self, t)))
	end,}

registerTalentTranslation{
	id = "T_SUPERCHARGE_BULLETS",
	name = "超速子弹",
	info = function(self, t)
		return ([[精 心 打 磨 子 弹 ， 接 下 来 的 %d 回 合 内 ， 你 的 子 弹 能 够 穿 透 多 个 目 标。
		同 时 提 高 护 甲 穿 透 %d 点。
		一 次 只 能 使 用 一 种 弹 药 强 化 能 力。]]):
		format(t.getTurns(self, t), t.getPower(self, t))
	end,}

registerTalentTranslation{
	id = "T_PERCUSSIVE_BULLETS",
	name = "冲击子弹",
	info = function(self, t)
		return ([[为 了 提 高 子 弹 的 冲 击 力 ， 换 用 了 巨 型 子 弹 。
		接 下 来 的 %d 回 合 内， 你 的 子 弹 击 中 时 有 %d%% 概 率 击 退 目 标 3 码 ， 同 时 有 %d%% 概 率 震 慑 目 标 3 回 合。
		击 退 和 震 慑 概 率 受 蒸 汽 强 度 影 响。
		一 次 只 能 使 用 一 种 弹 药 强 化 能 力。]]):
		format(t.getTurns(self, t), t.getKBChance(self, t), t.getStunChance(self, t))
	end,}

registerTalentTranslation{
	id = "T_COMBUSTIVE_BULLETS",
	name = "爆炸子弹",
	info = function(self, t)
		return ([[在 子 弹 上 覆 盖 了 可 燃 材 料 。 在 接 下 来 的 %d 回 合 ， 子 弹 在 击 中 目 标 后 都 会 爆 炸 ， 对 2 码 范 围 内 的 敌 人 造 成 %0.2f 火 焰 伤 害 （ 大 多 数 射 击 技 能 一 次 发 射 两 枚 弹 药 ）。
		伤 害 随 蒸 汽 强 度 提 高 。
		一 次 只 能 使 用 一 种 弹 药 强 化 能 力。]]):
		format(t.getTurns(self, t), damDesc(self, DamageType.FIRE, t.getDam(self, t)))
	end,}
return _M