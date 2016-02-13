local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DEATH_DANCE",
	name = "死亡之舞",
	info = function(self, t)
		return ([[原 地 旋 转， 伸 展 你 的 武 器， 伤 害 你 周 围 所 有 的 目 标， 造 成 %d%% 武 器 伤 害。]]):format(100 * self:combatTalentWeaponDamage(t, 1.4, 2.1))
	end,
}

registerTalentTranslation{
	id = "T_BERSERKER",
	name = "狂暴",
	info = function(self, t)
		return ([[进 入 狂 暴 的 战 斗 状 态， 以 减 少 10 点 闪 避 和 10 点 护 甲 的 代 价 增 加 %d 点 命 中 和 %d 点 物 理 强 度。 
		开 启 狂 暴 时 你 无 人 能 挡， 增 加 %d%% 震 慑 和 定 身 抵 抗。 
		受 敏 捷 影 响， 命 中 有 额 外 加 成； 
		受 力 量 影 响， 物 理 强 度 有 额 外 加 成。]]):
		format( t.getAtk(self, t), t.getDam(self, t), t.getImmune(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_WARSHOUT",
	name = "战争怒吼",
	info = function(self, t)
		return ([[在 你 的 正 前 方 大 吼 形 成 %d 码 半 径 的 扇 形 战 争 怒 吼。 任 何 在 其 中 的 目 标 会 被 混 乱 %d 回 合。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DEATH_BLOW",
	name = "致命打击",
	info = function(self, t)
		return ([[试 图 施 展 一 次 致 命 打 击， 造 成 %d%% 武 器 伤 害， 本 次 攻 击 自 动 变 成 暴 击。 
		如 果 打 击 后 目 标 生 命 值 低 于 20%% 则 有 可 能 直 接 杀 死。 
		在 等 级 4 时 会 消 耗 剩 余 的 耐 力 值 的 一 半 并 增 加 100%% 所 消 耗 耐 力 值 的 伤 害。 
		受 物 理 强 度 影 响， 目 标 即 死 的 概 率 有 额 外 加 成。]]):format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.3))
	end,
}

registerTalentTranslation{
	id = "T_STUNNING_BLOW",
	name = "震慑打击",
	info = function(self, t)
		return ([[用 你 的 武 器 攻 击 目 标 并 造 成 %d%% 伤 害。 如 果 此 次 攻 击 命 中， 则 目 标 会 震 慑 %d 回 合。 
		受 物 理 强 度 影 响， 震 慑 概 率 有 额 外 加 成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 1, 1.5), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SUNDER_ARMOUR",
	name = "破甲",
	info = function(self, t)
		return ([[用 你 的 武 器 攻 击 目 标 并 造 成 %d%% 伤 害。 如 果 此 次 攻 击 命 中， 则 目 标 护 甲 和 豁 免 会 减 少 %d 持 续 %d 回 合。 
		同 时， 如 果 目 标 被 临 时 伤 害 护 盾 保 护 ， 有 %d%% 几 率 使 之 破 碎。
		受 物 理 强 度 影 响， 护 甲 减 值 有 额 外 增 加。 ]])
		:format(100 * self:combatTalentWeaponDamage(t, 1, 1.5),t.getArmorReduc(self, t), t.getDuration(self, t), t.getShatter(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SUNDER_ARMS",
	name = "破刃",
	info = function(self, t)
		return ([[用 你 的 武 器 攻 击 目 标 并 造 成 %d%% 伤 害。 如 果 此 次 攻 击 命 中， 则 目 标 命 中 会 减 少 %d 持 续 %d 回 合。 
		受 物 理 强 度 影 响， 命 中 减 值 有 额 外 加 成。 ]])
		:format(
			100 * self:combatTalentWeaponDamage(t, 1, 1.5), 3 * self:getTalentLevel(t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_FRENZY",
	name = "血之狂暴",
	info = function(self, t)
		return ([[进 入 血 之 狂 暴 状 态， 快 速 消 耗 体 力（ -4 体 力 / 回 合）。 每 次 你 在 血 之 狂 暴 状 态 下 杀 死 一 个 敌 人， 你 可 以 获 得 %d 物 理 强 度 增 益。 
		每 回 合 增 益 减 2 。]]):
		format(t.bonuspower(self,t))
	end,
}


return _M
