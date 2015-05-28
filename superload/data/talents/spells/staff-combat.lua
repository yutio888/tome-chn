local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CHANNEL_STAFF",
	name = "魔法箭",
	info = function(self, t)
		local damagemod = t.getDamageMod(self, t)
		return ([[引 导 冰 冷 的 法 力 穿 过 你 的 法 杖， 发 射 出 1 道 能 造 成 %d%% 法 杖 伤 害 的 魔 法 箭。 
		 这 道 魔 法 可 以 安 全 的 穿 过 己 方 队 友， 只 会 对 敌 方 目 标 造 成 伤 害。 
		 此 攻 击 能 100%% 命 中 并 无 视 目 标 护 甲。
		 法 杖 的 伤 害 系 数 会 增 加 0.2 。]]):
		format(damagemod * 100)
	end,
}

registerTalentTranslation{
	id = "T_STAFF_MASTERY",
	name = "法杖掌握",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[增 加 %d 点 物 理 强 度。 同 时 法 杖 伤 害 增 加 %d%% 。]]):
		format(damage, 100 * inc)
	end,
}

registerTalentTranslation{
	id = "T_DEFENSIVE_POSTURE",
	name = "闪避姿态",
	info = function(self, t)
		local defense = t.getDefense(self, t)
		return ([[采 取 闪 避 姿 态， 增 加 你 %d 点 闪 避 和 护 甲 值。]]):
		format(defense)
	end,
}

registerTalentTranslation{
	id = "T_BLUNT_THRUST",
	name = "钝器挥击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local dazedur = t.getDazeDuration(self, t)
		return ([[挥 动 法 杖 对 目 标 造 成 %d%% 近 程 伤 害 并 震 慑 目 标 %d 回 合。 
		 受 法 术 强 度 影 响， 震 慑 概 率 有 额 外 加 成。 
		 在 等 级 5 时， 此 攻 击 必 中。]]):
		format(100 * damage, dazedur)
	end,
}


return _M
