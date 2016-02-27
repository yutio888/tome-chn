local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STRAFE",
	name = "扫射",
	info = function(self, t)
		local nb = t.getNb(self, t)
		return ([[你 学 会 如 何 在 移 动 中 射 击 。
		在 射 击 （100%% 武 器 伤 害 ， 射 程 -1 ）的 同 时 你 能 移 动 到 相 邻 的 一 格 。
		该 技 能 在 冷 却 前 能 激 活 连 续 %d 个 回 合 ， 消 耗 时 间 取 决 于 蒸 汽 速 度 和 移 动 速 度 较 慢 者 。
		扫 射 结 束 后 ， 你 立 刻 获 得 %d 到 %d 弹 药 （ 取 决 于 扫 射 期 间 你 消 耗 的 弹 药 与 你 的 弹 药 容 量 ） 。]]):
		format(nb, t.getReload(self, t, 1), t.getReload(self, t, nb + 1))
	end,}

registerTalentTranslation{
	id = "T_STARTLING_SHOT",
	name = "惊艳射击",
	info = function(self, t)
		return ([[你 故 意 朝 目 标 射 出 偏 离 的 子 弹 ， 令 其 惊 讶 3 回 合 。
		若 目 标 未 通 过 精 神 豁 免 检 定 ， 将 后 退 2 步 。
		惊 讶 状 态 下 的 目 标 在 下 一 次 攻  击 中 将 受 到 额 外 %d%% 伤 害 。]])
		:format(100 * self:combatTalentWeaponDamage(t, 1.5, 3))
	end,}

registerTalentTranslation{
	id = "T_EVASIVE_SHOTS",
	name = "反击射击",
	info = function(self, t)
		return ([[开 启 引 擎 强 化 反 射 神 经 ， 你 能 进 行 反 击 射 击 , 造 成 %d%% 武 器 伤 害。
		反 击 射 击 是 当 你 闪 避 或 躲 避 近 战 、 远 程 攻 击 时 触 发 的 自 动  射 击。
		反 击 射 击 一 回 合 只 能 触 发 一 次 ， 且 照 常 消 耗 弹 药 。]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.4, 1.5))
	end,}

registerTalentTranslation{
	id = "T_TRICK_SHOT",
	name = "魔术射击",
	info = function(self, t)
		local main, ammo, off = self:hasDualArcheryWeapon("steamgun")
		local accy = main and ammo and self:combatAttackRanged(main.combat, ammo.combat) or 0
		local ricoaccy = 1-t.ricochetAccuracy(self, t)
		return ([[你 的 灵 敏 让 你 能 射 出 同 时 击 中 多 个 敌 人 的 子 弹。
		你 精 确 地 瞄 准 敌 人 ， 子 弹 命 中 后 将 弹 射 至 其 他 目 标 上 。
		子 弹 最 多 弹 射 %d 次 ， 只 能 在 第 一 个 目 标 周 围 5 码 范 围 内 弹 射 ， 不 会 命 中 同 一 个 目 标 两 次 。
		第 一 次 命 中 将 造 成 %d%% 武 器 伤 害 ， 之 后 每 次 弹 射 下 降 %d%% 伤 害 和 %d （ %d%% ） 命 中 。]]):
		format(t.getNb(self, t), 100 * t.damageMult(self, t), (1-t.ricochetDamage(self, t))*100, accy*ricoaccy, ricoaccy*100)
	end,}
return _M