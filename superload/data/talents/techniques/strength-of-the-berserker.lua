local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WARSHOUT_BERSERKER",
	name = "战争怒吼",
	info = function(self, t)
		return ([[在 你 的 正 前 方 大 吼 形 成 %d 码 半 径 的 扇 形 战 争 怒 吼。 任 何 在 其 中 的 目 标 会 被 混 乱 %d 回 合。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BERSERKER_RAGE",
	name = "狂战之怒",
	info = function(self, t)
		return ([[进 入 狂 暴 的 战 斗 状 态， 增 加 %d 点 命 中 和 %d 点 物 理 强 度， 增 加 %d%% 震 慑 和 定 身 抵 抗。
		同 时 狂 暴 的 力 量 会 支 配 你 的 身 体 ， 每 回 合 损 失 2%% 生 命 。 同 时 ， 你 每 失 去 1%% 生 命 ， 增 加 0.5%% 暴 击 率 。
		该 技 能 只 在 视 野 内 有 敌 人 时 生 效 。
		受 敏 捷 影 响， 命 中 有 额 外 加 成； 
		受 力 量 影 响， 物 理 强 度 有 额 外 加 成。]]):
		format( t.getAtk(self, t), t.getDam(self, t), t.getImmune(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_SHATTERING_BLOW",
	name = "破碎震击",
	info = function(self, t)
		return ([[用 你 的 武 器 攻 击 目 标 并 造 成 %d%% 伤 害。 如 果 此 次 攻 击 命 中， 则 目 标 护 甲 和 豁 免 会 减 少 %d 持 续 %d 回 合。 
		同 时， 如 果 目 标 被 临 时 伤 害 护 盾 保 护 ， 有 %d%% 几 率 使 之 破 碎。
		受 物 理 强 度 影 响， 护 甲 减 值 有 额 外 增 加。]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.5), t.getArmorReduc(self, t), t.getDuration(self, t), t.getShatter(self, t))
	end,
}

registerTalentTranslation{
	id = "T_RELENTLESS_FURY",
	name = "无尽愤怒",
	info = function(self, t)
		return ([[激 发 你 内 在 的 力 量 ， 持 续 %d 回 合 。
		每 回 合 恢 复 %d 体 力 ， 同 时 增 加 %d%% 移 动 速 度 和 攻 击 速 度。
		只 能 在 体 力 少 于 30%% 时 使 用 。
		体 力 回 复 受 体 质 加 成 。]]):
		format(t.getDur(self, t), t.getStamina(self, t), t.getSpeed(self, t))
	end,
}


return _M
