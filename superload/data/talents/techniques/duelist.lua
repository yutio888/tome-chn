local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DUAL_WEAPON_MASTERY",
	name = "双持掌握",
	info = function (self,t)
		mult = t.getoffmult(self,t)*100
		block = t.getDamageChange(self, t, true)
		chance = t.getDeflectChance(self,t)
		return ([[你 的 副 手 武 器 惩 罚 减 少 至  %d%% .
		每 回 合 最 多 %0.1f 次，你 有 %d%% 概 率 抵 挡 至 多 %d 点 伤 害 （基 于 副 手 伤 害  ）。 
		抵 挡 的 减 伤 类 似 护 甲 ，且 被 抵 挡 的 攻 击 不 会 暴 击。 很 难 抵 挡 未 发 现 的 敌 人 的 攻 击 ， 且 不 能 使 用 灵 晶 抵 挡 攻 击 。
		]]):
		format(100 - mult, t.getDeflects(self, t, true), chance, block)
	end,
}
registerTalentTranslation{
	id = "T_TEMPO",
	name = "节奏",
	info = function (self,t)
		local sta = t.getStamina(self,t)
		local speed = t.getSpeed(self,t)
		return ([[战 斗 鼓 舞 着 你，让 你 在 战 斗 中 获 得 优 势。
		每 回 合 一 次 ， 若 你 双 持 武 器 ， 你 将 ：
		反 击 -- 如 果 你 闪 避 或 抵 挡 了 近 战 或 弓 箭 攻 击 ，你 立 刻 回 复 %0.1f 体 力 并 获 得 %d%% 额 外 回 合。
		回 复 -- 副 手 武 器 暴 击 时 回 复 %0.1f 体 力 。]]):format(sta, speed, sta)
	end,
}
registerTalentTranslation{
	id = "T_FEINT",
	name = "佯攻",
	info = function (self,t)
		return ([[假 装 攻 击 敌 人， 欺 骗 敌 人 和 你 换 位。 在 移 动 时 趁 机 削 弱 敌 人 ，使 其 定 身 并 眩 晕 2 回 合。
		换 位 令 你 的 敌 人 分 心 ， 使 你 的 闪 避 得 到 强 化： %d 回 合 内， 双 持 掌 握 提 供 额 外 一 次 抵 挡 攻 击 机 会，你 错 失 抵 挡 机 会 的 几 率 下 降 %d%% 。
		定 身 与 眩 晕 几 率 受 命 中 加 成。]]):
		format(t.getDuration(self, t), t.getParryEfficiency(self, t))
	end,
}
registerTalentTranslation{
	id = "T_LUNGE",
	name = "刺击",
	info = function (self,t)
		local dam = t.getDamage(self, t)
		local dur = t.getDuration(self,t)
		return ([[你 攻 其 不 备，用 副 手 发 起 致 命 打 击 ，造 成 %d%% 伤 害 并 使 其 武 器 脱 落 ，缴 械 %d 回 合 。
		节 奏 技 能 被 触 发 时 ， 该 技 能 的 冷 却 时 间 减 少 1 回 合。
		缴 械 几 率 受 命 中 加 成 。]]):
		format(dam*100, dur)
	end,
}
return _M