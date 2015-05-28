local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_OOZEBEAM",
	name = "软泥射线",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[ 在 你 的 心 灵 利 刃 里 充 填 史 莱 姆 能 量， 延 展 攻 击 范 围, 形 成 一 道 射 线， 造 成 %0.1f 点 史 莱 姆 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.NATURE, dam))
	end,
}

registerTalentTranslation{
	id = "T_NATURAL_ACID",
	name = "自然酸化",
	info = function(self, t)
		return ([[ 你 的 自 然 抗 性 增 加 %d%% 。
		 当 你 造 成 酸 性 伤 害 时 ， 你 的 自 然 伤 害 增 加 %0.1f%% ， 持 续 %d 回 合。
		 伤 害 加 成 能 够 积 累 到 最 多 4 倍 （ 1 回 合 至 多 触 发 1 次 ） ， 最 大 值 %0.1f%% 。
		 受 精 神 强 度 影 响 ， 抗 性 和 伤 害 加 成 有 额 外 加 成 。]]):
		format(t.getResist(self, t), t.getNatureDamage(self, t, 1), t.getDuration(self, t), t.getNatureDamage(self, t, 5))
	end,
}

registerTalentTranslation{
	id = "T_MIND_PARASITE",
	name = "精神寄生",
	info = function(self, t)
		return ([[你 利 用 你 的 心 灵 利 刃 朝 你 的 敌 人 发 射 一 团 蠕 虫。 
		 当 攻 击 击 中 时， 它 会 进 入 目 标 大 脑， 并 在 那 里 待 6 回 合， 干 扰 对 方 使 用 技 能 的 能 力。 
		 每 次 对 方 使 用 技 能 时， 有 %d%% 概 率 %d 个 技 能 被 打 入 %d 个 回 合 的 冷 却。 
		 受 精 神 强 度 影 响， 概 率 有 额 外 加 成。]]):
		format(t.getChance(self, t), t.getNb(self, t), t.getTurns(self, t))
	end,
}

registerTalentTranslation{
	id = "T_UNSTOPPABLE_NATURE",
	name = "自然世界",
	info = function(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local chance = t.getChance(self, t)
		return ([[你 的 周 围 充 满 了 自 然 力 量， 忽 略 目 标 %d%% 的 自 然 伤 害 抵 抗。 
		 同 时， 每 次 你 使 用 自 然 力 量 造 成 伤 害 时， 有 %d%% 概 率 你 的 一 个 粘 液 软 泥 怪 会 向 目 标 释 放 喷 吐， 这 个 攻 击 不 消 耗 时 间。]])
		:format(ressistpen, chance)
	end,
}


return _M
