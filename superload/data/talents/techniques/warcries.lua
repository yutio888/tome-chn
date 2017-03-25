local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHATTERING_SHOUT",
	name = "狮子吼",
	info = function(self, t)
		return ([[一 次 强 有 力 的 怒 吼， 在 你 前 方 锥 形 区 域 内 造 成 %0.2f 物 理 伤 害（ 有 效 半 径 %d 码）。
		等 级 5 时 ， 怒 吼 变 得 如 此 强 烈 ， 范 围 内 的 抛 射 物 会 被 击 落。
		受 力 量 影 响， 伤 害 有 额 外 加 成。 ]])
		:format(damDesc(self, DamageType.PHYSICAL, t.getdamage(self,t)), t.radius(self,t))
	end,
}

registerTalentTranslation{
	id = "T_SECOND_WIND",
	name = "宁神之风",
	info = function(self, t)
		return ([[做 一 次 深 呼 吸 并 恢 复 %d 体 力 值。该 效 果 受 意 志 和 力 量 加 成。]]):
		format(t.getStamina(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BATTLE_SHOUT",
	name = "战斗鼓舞",
	info = function(self, t)
		return ([[当 你 鼓 舞 后， 提 高 你 %0.1f%% 生 命 值 和 体 力 值 上 限 持 续 %d 回 合。
		效 果 结 束 时 ， 增 加 的 生 命 和 体 力 会 消 失。]]):
		format(t.getPower(self, t), t.getdur(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BATTLE_CRY",
	name = "战斗怒喝",
	info = function(self, t)
		return ([[你 的 怒 喝 会 减 少 %d 码 半 径 范 围 内 敌 人 的 意 志， 减 少 它 们 %d 闪 避， 持 续 7 回 合。 
		同 时， 所 有 的 闪 避 加 成 会 被 取 消。
		受 物 理 强 度 影 响， 命 中 率 有 额 外 加 成。]]):
		format(self:getTalentRadius(t), 7 * self:getTalentLevel(t))
	end,
}


return _M
