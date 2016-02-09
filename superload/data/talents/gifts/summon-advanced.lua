local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MASTER_SUMMONER",
	name = "召唤精通",
	info = function(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[降 低 所 有 召 唤 系 技 能 %d%% 冷 却 时 间。]]):
		format(cooldownred * 100)
	end,
}

registerTalentTranslation{
	id = "T_GRAND_ARRIVAL",
	name = "野性降临",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[当 召 唤 精 通 激 活 时， 每 个 召 唤 兽 出 现 在 世 界 上 时， 它 会 触 发 1 个 野 性 效 果： 
		 - 里 奇 之 焰： 减 少 范 围 内 所 有 敌 人 的 火 焰 抵 抗 
		 - 三 头 蛇： 生 成 一 片 持 续 的 毒 雾 
		 - 雾 凇： 减 少 范 围 内 所 有 敌 人 的 寒 冷 抵 抗 
		 - 火 龙： 出 现 %d 只 小 火 龙 
		 - 战 争 猎 犬： 减 少 范 围 内 所 有 敌 人 的 物 理 抵 抗 
		 - 史 莱 姆： 减 少 范 围 内 所 有 敌 人 的 自 然 抵 抗 
		 - 米 诺 陶 斯： 减 少 范 围 内 所 有 敌 人 的 移 动 速 度 
		 - 岩 石 傀 儡： 眩 晕 范 围 内 所 有 敌 人 
		 - 乌 龟： 治 疗 范 围 内 所 有 友 军 单 位 
		 - 蜘 蛛： 蜘 蛛 如 此 的 丑 陋， 以 至 于 附 近 所 有 敌 人 都 会 被 吓 退。
		 效 果 范 围 %d ， 每 个 持 续 效 果 维 持 %d 回 合 。 
		 受 意 志 影 响， 效 果 有 额 外 加 成。]]):format(t.nbEscorts(self, t), radius, t.effectDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_NATURE_CYCLE",
	name = "自然之环",
	info = function(self, t)
		return ([[当 召 唤 精 通 激 活 时， 每 出 现 新 的 召 唤 兽 会 减 少 狂 怒、 引 爆 和 野 性 召 唤 的 冷 却 时 间。 
		%d%% 概 率 减 少 它 们 %d 回 合 冷 却 时 间。]]):format(t.getChance(self, t), t.getReduction(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WILD_SUMMON",
	name = "野性召唤",
	info = function(self, t)
		return ([[你 在 %d 回 合 内 100%% 召 唤 出 一 只 野 性 模 式 的 召 唤 兽。 
		 此 概 率 每 回 合 递 减。
		 野 性 召 唤 兽 增 加 1 个 新 的 天 赋： 
		- 里 奇 之 焰： 使 身 上 围 绕 一 团 火 焰 并 击 退 敌 人 
		- 三 头 蛇： 可 以 从 近 战 中 脱 离 
		- 雾 凇： 提 高 魔 法 抵 抗 
		- 火 龙： 可 以 用 怒 吼 来 沉 默 敌 人 
		- 战 争 猎 犬： 可 以 狂 暴， 增 加 它 的 暴 击 率 和 护 甲 穿 透 值 
		- 史 莱 姆： 可 以 吞 掉 生 命 值 较 低 的 敌 人， 回 复 你 的 自 然 失 衡 值 
		- 米 诺 陶 斯： 可 以 向 目 标 冲 锋 
		- 岩 石 傀 儡： 近 战 攻 击 有 溅 射 效 果 
		- 乌 龟： 可 以 嘲 讽 范 围 内 敌 人 进 入 近 战 状 态 
		- 蜘 蛛： 可 以 向 目 标 吐 出 剧 毒， 减 少 它 们 的 治 疗 效 果 
		 此 技 能 只 有 在 召 唤 精 通 激 活 时 才 能 使 用。]]):format(t.duration(self,t))
	end,
}


return _M
