local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_OVERGROWTH",
	name = "过度生长",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local slow = t.getSlow(self, t)
		local pin = t.getPin(self, t)
		local radius = self:getTalentRadius(t)
		return ([[瞬 间 在 半 径 %d 码 的 区 域 内 长 出 苔 藓 圈。
		每 回 合 苔 藓 会 对 其 中 的 敌 人 造 成 %0.2f 的 自 然 伤 害。
		这 些 又 厚 又 粘 的 苔 藓 会 让 途 经 他 们 的 敌 人 移 动 速 度 下 降 %d%% 并 且 有 %d%% 的 几 率 被 定 身 4 回 合。
		苔 藓 能 持 续 %d 回 合。
		苔 藓 技 能 都 是 瞬 发 的， 但 是 会 让 其 他 的 苔 藓 技 能 进 入 冷 却 3 回 合。
		伤 害 会 随 着 你 的 精 神 强 度 增 加。]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), slow, pin, duration)
	end,
}

registerTalentTranslation{
	id = "T_TALOSIS_CEASEFIRE",
	name = "停火",
	info = function(self, t)
		return ([[你 向 一 个 敌 人 射 出 一 发 威 力 无 穷 的 子 弹， 造 成 %d%% 伤 害 并 眩 晕 他 们 %d 回 合。
		眩 晕 几 率 会 随 着 你 的 蒸 汽 强 度 增 加。]]):format(100 * self:combatTalentWeaponDamage(t, 1, 1.8), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_GUN_SUREKILL",
	name = "一击必杀",
	info = function(self, t)
		return ([[你 向 一 个 敌 人 射 出 一 发 无 比 致 命 的 子 弹， 造 成 %d%% 伤 害。
		如 果 能 杀 死 敌 人， 那 么 伤 害 会 提 升 你 暴 击 伤 害 系 数 的 一 半。]]):format(100 * self:combatTalentWeaponDamage(t, 1, 1.8))
	end,}

registerTalentTranslation{
	id = "T_ROCKET_SMASH",
	name = "火箭重击",
	info = function(self, t)
		return ([[借 助 火 箭 向 前 突 击。
		如 果 目 标 地 点 已 被 占 据， 那 么 你 到 达 的 时 候 会 对 目 标 进 行 一 次 近 战 攻 击 并 击 退 他 和 任 何 被 他 撞 到 的 目 标 4 码。
		这 个 攻 击 会 造 成 180% 武 器 伤 害。
		你 必 须 突 击 至 少 2 格。]])
	end,}

return _M