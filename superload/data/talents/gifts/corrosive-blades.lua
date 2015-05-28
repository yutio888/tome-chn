local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ACIDBEAM",
	name = "酸性射线",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[ 在 你 的 心 灵 利 刃 里 充 填 酸 性 能 量， 延 展 攻 击 范 围, 形 成 一 道 射 线， 造 成 %0.1f 点 酸 性 缴 械 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ACID, dam))
	end,
}

registerTalentTranslation{
	id = "T_CORROSIVE_NATURE",
	name = "自然腐蚀",
	info = function(self, t)
		return ([[ 你 的 酸 性 抗 性 增 加 %d%% 。
		 当 你 造 成 自 然 伤 害 时 ， 你 的 酸 性 伤 害 增 加 %0.1f%% ， 持 续 %d 回 合。
		 伤 害 加 成 能 够 积 累 到 最 多 4 倍 （ 1 回 合 至 多 触 发 1 次 ） ， 最 大 值 %0.1f%% 。
		 受 精 神 强 度 影 响 ， 抗 性 和 伤 害 加 成 有 额 外 加 成 。]]):
		format(t.getResist(self, t), t.getAcidDamage(self, t, 1), t.getDuration(self, t), t.getAcidDamage(self, t, 5))
	end,
}

registerTalentTranslation{
	id = "T_CORROSIVE_SEEDS",
	name = "腐蚀之种",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local nb = t.getNb(self, t)
		return ([[ 你 集 中 精 神 于 某 块 半 径 2 的 区 域， 制 造 出 %d 个 腐 蚀 之 种。 
		 第 一 个 种 子 会 产 生 于 中 心 处 ， 其 他 的 会 随 机 出 现。
         每 个 种 子 持 续 %d 回 合，
		 当 一 个 生 物 走 过 腐 蚀 之 种 时， 会 在 半 径 1 的 区 域 内 引 发 一 场 爆 炸， 击 退 对 方 并 造 成 %0.1f 点 酸 性 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成]]):
		format(nb, t.getDuration(self, t), damDesc(self, DamageType.ACID, dam))
	end,
}

registerTalentTranslation{
	id = "T_ACIDIC_SOIL",
	name = "酸化大地",
	info = function(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local regen = t.getRegen(self, t)
		return ([[ 你 的 周 围 充 满 了 自 然 力 量， 忽 略 目 标 %d%% 的 酸 性 伤 害 抵 抗。 
		 同 时 酸 性 能 量 会 治 疗 你 的 浮 肿 软 泥 怪， 增 加 他 们 每 回 合 %0.1f 的 生 命 回 复。]])
		:format(ressistpen, regen)
	end,
}


return _M
