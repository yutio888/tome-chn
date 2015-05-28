local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_OBLITERATING_SMASH",
	name = "歼灭挥斩",
	info = function(self, t)
	return ([[用 无 与 伦 比 的 力 量 挥 动 武 器 ， 打 击 正 面 半 圆 %d 码 范 围 内 所 有 敌 对 生 物 ， 对 所 有 目 标 造 成 %d%% 武 器 伤 害。
	技 能 5 级 时 ， 被 击 中 敌 对 生 物 的 护 甲 和 豁 免 会 降 低 %d 点。
	此 攻 击 必 中。]]):
	format(self:getTalentRange(t), 100 * t.getDamage(self, t), t.getSunder(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_DETONATING_CHARGE",
	name = "爆裂冲锋",
	info = function(self, t)
	return ([[向 目 标 冲 锋 ， 如 果 到 达 目 标 位 置 ， 则 攻 击 目 标 造 成 %d%% 武 器 伤 害 。
	若 攻 击 命 中 ，将 释 放 强 烈 的 火 焰 冲 击，击 退 %d 码 之 内 目 标 之 外 的 所 有 敌 对 生 物 。
	至 少 要 从 2 码 外 开 始 冲 锋。]]):format(t.getMainHit(self,t) * 100, t.fireRadius(self,t), t.getDamage(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_VORACIOUS_BLADE",
	name = "饕餮之刃",
	info = function(self, t)
	return ([[你 的 利 刃 充 满 着 对 杀 戮 的 渴 望。
	在 技 能 冷 却 完 毕 后， 当 杀 死 敌 人 时，接 下 来 6 回 合 内 的 %d 次 近 战 攻 击 必 定 暴 击 ， 在 持 续 时 间 内 ，暴 击 系 数 增 加 %d%% 。
	另 外 ， 每 次 击 杀 时 额 外 获 得 %d 点 活 力。]]):format(t.getHits(self, t), t.getMult(self, t), t.vimBonus(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_DESTROYER",
	name = "毁灭者",
	info = function(self, t)
		local dest = t.getDestroy(self, t)
		return ([[恶 魔 空 间 的 力 量 充 溢 了 你 的 身 体 ， 将 你 转 换 成 一 个 强 大 的 恶魔 ， 持 续 %d 回 合 。 
	变 身 期 间 ， 体 力 恢 复 和 物 理 强 度 增 加 %d ， 缴 械 和 震 慑 抗 性 增加 %d%% 。
	物 理 强 度 ， 体 力 恢 复 ， 状 态 抗 性 加 值 受 法 力 强 度 加 成。
	变 身 期 间 ， 其 他 技 能 也 受 到 强 化：
	汲 魂 痛 击 ： 冷 却 时 间 减 少 %d 。
	舍 身 一 击 ： 增 加 %d%% 全 体 抗 性 穿 透 ，持 续 %d 回 合。
	歼 灭 挥 斩 ： 增 加 半 径 %d 。
	锁 魂 之 链 ： 如 果 命 中 ， 额 外 附 加 %d 次 35%% 武 器 伤 害 的 攻 击。
	焚 尽 强 击 ： 增 加 额 外 伤 害 几 率 至 %d%% 。
	恐 惧 盛 宴 ： 每 汲 取 一 层 叠 加 的 恐 惧 ， 获 得 %0.1f 点 活 力。
	乌 鲁 克 之 胃 ： 角 度 增 加 %d 。]]):
	format(t.getDuration(self, t),
		t.getPower(self, t),
		math.min(math.ceil(t.getPower(self, t)/40 *100),100),
		math.ceil(dest/3),
		10 * dest, 3 + math.ceil(dest/2),
		math.ceil(dest/4),
		math.ceil(dest/2),
		25 + 10 * dest,
		dest * 0.4,
		dest * 10)
	end,
}


return _M
