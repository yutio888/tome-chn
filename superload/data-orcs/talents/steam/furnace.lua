local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FURNACE",
	name = "熔炉",
	info = function(self, t)
		local damageinc = t.getFireDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		return ([[你 往 蒸 汽 制 造 机 中 安 装 一个 便 携 式 熔 炉 。
		熔 炉 激 活 时 ， 你 的 物 理 和 火 焰 伤 害 增 加 %d%% ， 物 理 和 火 焰 抗 性 穿 透 增 加 %d%% 。
		#{italic}#用蒸汽烧尽一切！#{normal}#
		]]):
		format(damageinc, damageinc, ressistpen, ressistpen)
	end,}

registerTalentTranslation{
	id = "T_MOLTEN_METAL",
	name = "融化金属",
	info = function(self, t)
		local reduction = 1
		local mp = self:hasEffect(self.EFF_FURNACE_MOLTEN_POINT)
		if mp then reduction = 0.75 ^ mp.stacks end
		return ([[你 的 护 甲 温 度 极 高 ， 能 驱 散 部 分 能 量 攻 击 。
		所 有 非 物 理 、 非 精 神 伤 害 降 低 %d 点 （ 当 前 %d ） 。
		每 回 合 该 效 果 触 发 时 ， 你 获 得 1 点 融 化 点 数 （ 最 多 1 0 点 ） ， 减 少 25%% 减 伤 效 率 。
		奔 跑 和 休 息 将 取 消 融 化 点 数 。
		#{italic}#火热的液态金属，乐趣无穷！#{normal}#
		]]):format(t.getResist(self, t), t.getResist(self, t) * reduction)
	end,}


registerTalentTranslation{
	id = "T_FURNACE_VENT",
	name = "通风孔",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local mp = self:hasEffect(self.EFF_FURNACE_MOLTEN_POINT)
		local stacks = mp and mp.stacks or 0
		return ([[打 开 熔 炉 通 风 孔，制 造 锥 形 热 风 ， 在 1 0 点 融 化 点 数 时 造 成 最 多 %0.2f 火 焰 伤 害 （ 当 前 %0.2f 点 ）。
		消 耗 所 有 融 化 点 数 。
		#{italic}#让火焰净化一切！#{normal}#
		]]):
		format(damDesc(self, DamageType.FIRE, damage), damDesc(self, DamageType.FIRE, damage) * stacks / 10)
	end,}

registerTalentTranslation{
	id = "T_MELTING_POINT",
	name = "熔点",
	info = function(self, t)
		return ([[当 你 达 到 1 0 点 融 化 点 数 时 ， 你 的 护 甲 过 热 ， 温 度 极 高 ， 以 至 于 %d 个 负 面 物 理 状 态 被 高 温 驱 散 。
		同 时 ， 一 种 特 殊 的 药 物 注 射 器 将 注 射 一 种 火 焰 免 疫 药 剂 ， 令 你 免 疫 烧 伤 效 果 。
		该 效 果 触 发 时 ， 消 耗 所 有 融 化 点 数 ， 并 自 动 触 发 一 次 通 风 孔 效 果 ， 目 标 为 最 后 一 次 提 供 融 化 点 数 的 生 物 。 
		该 效 果 将 消 耗 1 5 点 蒸 汽 。 蒸 汽 不 足 时 不 能 触 发 。
		#{italic}#只是肉体在燃烧!#{normal}#
		]]):
		format(t.getNb(self, t))
	end,}
return _M