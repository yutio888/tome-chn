local _M = loadPrevious(...)

local function aura_mastery(self, t)
	return 0.5 --9 + self:getTalentLevel(t) * 2
end

registerTalentTranslation{
	id = "T_KINETIC_AURA",
	name = "动能光环",
	info = function(self, t)
		local dam = t.getAuraStrength(self, t)
		local spikedam = t.getAuraSpikeStrength(self, t)
		local mast = aura_mastery(self, t)
		local spikecost = t.getSpikeCost(self, t)
		return ([[将 你 周 围 的 空 气 充 满 能 量 力 场 。
		 如 果 你 的 灵 能 武 器 槽 佩 戴 的 是 宝 石 或 者 灵 晶 ，会 对 所 有 接 近 的 目 标 造 成 %0.1f 的 物 理 伤 害 。
		 动 能 光 环 造 成 的 伤 害 会 吸 收 能 量 ，每 造 成 %0.1f 点 伤 害 就 吸 收 一 点 能 量 。
		 如 果 你 的 灵 能 武 器 槽 佩 戴 的 是 武 器 ，每 次 攻 击 附 加 %0.1f 的 物 理 伤 害 。
		 当 关 闭 该 技 能 时 ，如 果 你 拥 有 最 少 %d 点 能 量 ，巨 大 的 动 能 会 释 放 为 一 个 射 程 为 %d 的 射 线 ，击 打 目 标 ，造 成 高 达 %d 的 物 理 伤 害 ，并 击 飞 他 们 。
		 #{bold#激 活 光 环 是 不 消 耗 时 间 的 ，但 是 关 闭 它 则 需 要 消 耗 时 间 。#{normal#
		 如 果 要 关 闭 光 环 且 不 发 射 射 线 ，关 闭 它 并 选 择 你 自 己 为 目 标 。伤 害 随 着 精 神 强 度 而 增 长 。]]):
		format(damDesc(self, DamageType.PHYSICAL, dam), mast, damDesc(self, DamageType.PHYSICAL, dam), spikecost, t.getSpikedRange(self, t),
		damDesc(self, DamageType.PHYSICAL, spikedam))
	end,
}

registerTalentTranslation{
	id = "T_THERMAL_AURA",
	name = "热能光环",
	info = function(self, t)
		local dam = t.getAuraStrength(self, t)
		local rad = t.getSpikedRadius(self,t)
		local spikedam = t.getAuraSpikeStrength(self, t)
		local mast = aura_mastery(self, t)
		local spikecost = t.getSpikeCost(self, t)
		return ([[将 你 周 围 的 空 气 充 满 火 炉 般 的 热 量 。
		 如 果 你 的 灵 能 武 器 槽 佩 戴 的 是 宝 石 或 灵 晶 ，会 对 所 有 接 近 的 目 标 造 成 %0.1f 的 火 焰 伤 害 。
		 热 能 光 环 造 成 的 伤 害 会 吸 收 能 量 ，每 造 成 %0.1f 点 伤 害 吸 收 一 点 能 量 。
		 如 果 你 的 灵 能 武 器 槽 佩 戴 的 是 武 器 ，每 次 攻 击 附 加 %0.1f 的 火 焰 伤 害 。
		 当 关 闭 该 技 能 时 ，如 果 你 拥 有 最 少 %d 点 能 量 ，巨 大 的 热 能 会 释 放 为 一 个 范 围 为 %d 的 锥 形 冲 击 。范 围 内 的 任 意 目 标 在 数 轮 中 受 到 高 达 %d 的 火 焰 伤 害 。
		#{bold#激 活 光 环 是 不 消 耗 时 间 的 ，但 是 关 闭 它 则 需 要 消 耗 时 间 。#{normal#
		 如 果 要 关 闭 光 环 且 不 发 射 射 线 ，关 闭 它 并 选 择 你 自 己 为 目 标 。伤 害 随 着 精 神 强 度 而 增 长 。]]):
		format(damDesc(self, DamageType.FIRE, dam), mast, damDesc(self, DamageType.FIRE, dam), spikecost, rad,
		damDesc(self, DamageType.FIRE, spikedam))
	end,
}

registerTalentTranslation{
	id = "T_CHARGED_AURA",
	name = "充能光环",
	info = function(self, t)
		local dam = t.getAuraStrength(self, t)
		local spikedam = t.getAuraSpikeStrength(self, t)
		local mast = aura_mastery(self, t)
		local spikecost = t.getSpikeCost(self, t)
		local nb = t.getNumSpikeTargets(self, t)
		return ([[将 你 周 围 的 空 气 充 满 噼 啪 响 的 电 能 。
		 如 果 你 的 灵 能 武 器 槽 佩 戴 的 是 宝 石 或 灵 晶 ，会 对 所 有 接 近 的 目 标 造 成 %0.1f 的 闪 电 伤 害 。
		 电 能 光 环 造 成 的 伤 害 会 吸 收 能 量 ，每 造 成 %0.1f 点 伤 害 吸 收 一 点 能 量 。
		 如 果 你 的 灵 能 武 器 槽 佩 戴 的 是 武 器 ，每 次 攻 击 附 加 %0.1f 的 闪 电 伤 害 。
		 当 关 闭 该 技 能 时 ，如 果 你 拥 有 最 少 %d 点 能 量 ，巨 大 的 电 能 会 释 放 为 在 最 多 %d 个 邻 近 目 标 间 跳 跃 的 闪 电 ，对 每 个 目 标 造 成 %0.1f 的 闪 电 伤 害 ，且 50%% 的 概 率 令 他 们 眩 晕 。
		#{bold#激 活 光 环 是 不 消 耗 时 间 的 ，但 是 关 闭 它 则 需 要 消 耗 时 间 。#{normal#
		 如 果 要 关 闭 光 环 且 不 发 射 射 线 ，关 闭 它 并 选 择 你 自 己 为 目 标 。伤 害 随 着 精 神 强 度 而 增 长 。]]):
		format(damDesc(self, DamageType.LIGHTNING, dam), mast, damDesc(self, DamageType.LIGHTNING, dam), spikecost, nb, damDesc(self, DamageType.LIGHTNING, spikedam))
	end,
}

registerTalentTranslation{
	id = "T_FRENZIED_FOCUS",
	name = "灵能狂热",
	info = function(self, t)
		local targets = t.getTargNum(self,t)
		local dur = t.duration(self,t)
		return ([[超 载 你 的 心 灵 聚 焦 %d 轮 ，造 成 特 殊 效 果 。
		 心 灵 传 动 武 器 进 入 狂 怒 中 ，每 轮 最 多 攻 击 %d 个 目 标 ，同 时 增 加 %d 格 攻 击 范 围 。
		 灵 晶 和 宝 石 会 对 一 个 距 离 6 以 内 的 随 机 敌 人 发 射 一 个 能 量 球 ，造 成 每 轮 %0.1f 的 伤 害 。伤 害 类 型 取 决 于 宝 石 的 颜 色 。伤 害 随 着 精 神 强 度 增 长 。]]):
		format(dur, targets, targets, t.getDamage(self,t))
	end,
}


return _M
