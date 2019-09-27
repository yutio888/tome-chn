local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STUNNING_BLOW_ASSAULT",
	name = "震慑打击",
	info = function(self, t)
		return ([[用 你 的 双 持 武 器 攻 击 目 标 两 次 并 造 成 %d%% 伤 害。 每 次 攻 击 都 会试 图 震 慑 目 标 %d 回 合。 
		受 物 理 强 度 影 响， 震 慑 概 率 有 加 成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.5, 0.7), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FEARLESS_CLEAVE",
	name = "无畏跳斩",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[向 前 跳 一步 ， 用这股力量对周围的目标 造 成 %d%% 武 器 伤 害。]])
		:format(damage)
	end,
}

registerTalentTranslation{
	id = "T_DEATH_DANCE_ASSAULT",
	name = "死亡之舞",
	info = function(self, t)
		return ([[原 地 旋 转， 伸 展 你 的 武 器， 伤 害 你 周 围半径%d范围内的所 有目 标， 造 成 %d%% 武 器 伤 害。
		等 级 3 时 ， 所 有 伤 害 会 引 发 额 外 %d%% 流 血 伤 害，持 续 5 回 合 。]]):format(self:getTalentRadius(t), 100 * self:combatTalentWeaponDamage(t, 1.4, 2.1), t.getBleed(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_EXECUTION",
	name = "致命斩杀",
	info = function(self, t)
		return ([[试 图 斩 杀 目 标 。 目 标 每 损 失 1 ％ 生 命 ， 你 造 成 额 外 %0.2f％ 武 器 伤 害。（剩 余 30 ％ 生 命 时 造 成 %0.2f％ 武 器 伤 害 ）
		该 攻 击 必 定 暴 击 。
		如果这一攻击杀死了敌人，你的两个技能的冷却时间减少两个回合，致命斩杀技能的冷却时间归零。]]):
		format(t.getPower(self, t), 100 + t.getPower(self, t) * 70)
	end,
}


return _M
