local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_PULSE_DETONATOR",
	name = "脉冲爆弹",
	info = function(self, t)
		return ([[向 目 标 位 置 发 射 一 发 脉 冲 爆 弹 ， 当 到 达 后 爆 炸 形 成 范 围 4 的 锥 形 冲 击 波 ， 对 范 围 内 敌 人 造 成 %0.2f 物 理 伤 害 ，击 退 3 码 并 造 成 %d 回 合 的 眩 晕。
		]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_FLYING_GRAPPLE",
	name = "飞爪擒拿",
	info = function(self, t)
		return ([[向 目 标 发 射 一 枚 自 动 制 导 的 蒸 汽 动 力 无 人 机 。
		 命 中 目 标 后 ， 无 人 机 向 4 码 内 的 所 有 方 向 发 射 金 属 飞 爪 。
		 飞 爪 会 抓 住 范 围 内 任 何 敌 人 ， 并 将 它 们 向 目 标 拉 扯 。
		 如 果 拉 扯 过 程 中 被 其 他 生 物 阻 挡， 两 者 均 受 到 %0.2f 物 理 伤 害 。
		]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}


registerTalentTranslation{
	id = "T_NET_PROJECTOR",
	name = "束网弹射器",
	info = function(self, t)
		return ([[向 目 标 发 射 一 张 范 围 2 码 的 轻 质 电 场 束 网 ， 范 围 内 的 所 有 生 物 会 被 定 身 在 原 地 ， 持 续 5 回 合 。
		虽 然 电 力 不 足 以 造 成 伤 害 ， 但 是 持 续 电 击 会 导 致 肢 体 麻 痹 ， 全 抗 性 降 低 %d%% 。]]):
		format(t.getResist(self, t))
	end,}

registerTalentTranslation{
	id = "T_SAWFIELD",
	name = "飞锯领域",
	info = function(self, t)
		return ([[发 射 出 大 量 的 小 型 飞 锯 环 绕 目 标 飞 行 ， 范 围 %d 码。 
		范 围 内 的 所 有 生 物 受 到 %0.2f 物 理 流 血 伤 害 。
		技 能 持 续 4 回 合 。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}
return _M