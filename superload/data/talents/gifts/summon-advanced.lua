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
		 - 火焰里奇： 减 少 范 围 内 所 有 敌 人 的 火 焰 抵 抗 %d%%
		 - 三 头 蛇： 生 成 一 片 持 续 的 毒 雾，范围内所有敌人每回合受到 %0.1f 自然伤害（可叠加）
		 - 雾 凇： 减 少 范 围 内 所 有 敌 人 的 寒 冷 抵 抗 %d%%
		 - 火 龙： 出 现 %d 只 小 火 龙 
		 - 战 争 猎 犬： 减 少 范 围 内 所 有 敌 人 的 物 理 抵 抗 %d%%
		 - 果冻怪： 减 少 范 围 内 所 有 敌 人 的 自 然 抵 抗 %d%%
		 - 米 诺 陶： 减 少 范 围 内 所 有 敌 人 的 移 动 速 度 %0.1f%%
		 - 岩 石 傀 儡： 眩 晕 范 围 内 所 有 敌 人 
		 - 乌 龟： 治 疗 范 围 内 所 有 友 军 单 位 %d 生命值
		 - 蜘 蛛： 定身范围内所有敌人。
		 效 果 范 围 %d ， 每 个 持 续 效 果 维 持 %d 回 合 。 
		 受 精神强度 影 响， 效 果 有 额 外 加 成。]]):format(t.resReduction(self, t), t.poisonDamage(self,t) / 6, t.resReduction(self, t), t.nbEscorts(self, t), t.resReduction(self, t), t.resReduction(self, t), 100*t.slowStrength(self,t), t.amtHealing(self,t), radius, t.effectDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_NATURE_CYCLE",
	name = "自然之环",
	info = function(self, t)
		return ([[当 召 唤 精 通 激 活 时， 每 出 现 新 的 召 唤 兽 会 减 少 信息素、 引 爆 和 野 性 召 唤 的 冷 却 时 间。 
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
		- 火 焰 里 奇： 可 以 在 空 中 飞 行， 吐 火 不 会 被 路 径 上 的 生 物 所 阻 挡 。
		- 三 头 蛇：如 果 发 现 友 军 会 被 击 中，则 将 吐 息 改 为 单 体 攻 击。
		- 雾 凇：可 以 抓 取 敌 人 ， 将 它 们 拉 进 自 己 的 冰 风 暴 范 围。
		- 火 龙： 可 以 用 怒 吼 来 沉 默 敌 人 
		- 战 争 猎 犬： 可 以 狂 暴， 增 加 它 的 暴 击 率 和 护 甲 穿 透 值 
		- 果 冻 怪： 可 以 在 被 攻 击 造 成 较 大 伤 害 的 时 候 ， 分 裂 出 一 个 果 冻 怪（ 分 裂 出 的 果 冻 怪 不 会 占 用 你 的 召 唤 物 上 限）
		- 米 诺 陶： 可 以 向 目 标 冲 锋 
		- 岩 石 傀 儡： 可以缴械敌人。
		- 乌 龟： 可 以 嘲 讽 范 围 内 敌 人 进 入 近 战 状 态 
		- 蜘 蛛： 可 以 向 目 标 吐 出 剧 毒， 减 少 它 们 的 治 疗 效 果 
		此 技 能 只 有 在 召 唤 精 通 激 活 时 才 能 使 用。
		技 能 效 果 受 召 唤 物 技 能 等 级 加 成。]]):format(t.duration(self,t))
	end,
}


return _M
