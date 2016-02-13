local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LIGHTNING_INFUSION",
	name = "闪电充能",
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
		return ([[ 将 闪 电 能 量 填 充 至 炼 金 炸 弹 ， 能 眩 晕 敌 人 。
		 你 造 成 的 闪 电 伤 害 增 加 %d%% 。]]):
		format(daminc)
	end,
}

registerTalentTranslation{
	id = "T_DYNAMIC_RECHARGE",
	name = "动态充能",
	info = function(self, t)
		return ([[ 当 闪 电 充 能 开 启 时 ， 你 的 炸 弹 会 给 傀 儡 充 能 。
		 你 的 傀 儡 的 所 有 冷 却 中 技 能 有 %d%% 概 率 减 少 %d 回 合 冷 却 时 间。]]):
		format(t.getChance(self, t), t.getNb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THUNDERCLAP",
	name = "闪电霹雳",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 粉 碎 一 颗 炼 金 宝 石 ， 制 造 一 次 闪 电 霹 雳 ， 在 半 径 %d 的 锥 形 区 域 内 造 成 %0.2f 点 物 理 伤 害 和 %0.2f 点 闪 电 伤 害。
		 范 围 内 的 生 物 将 会 被 击 退 并 被 缴 械 %d 回 合 。
		 受 法 术 强 度 影 响 ， 伤 害 和 持 续 时 间 有 额 外 加 成。]]):format(radius, damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_LIVING_LIGHTNING",
	name = "闪电之体",
	info = function(self, t)
		local speed = t.getSpeed(self, t) * 100
		local dam = t.getDamage(self, t)
		local turn = t.getTurn(self, t)
		local range = self:getTalentRange(t)
		return ([[ 将 闪 电 能 量 填 充 到 身 体 中 ， 增 加 %d%% 移 动 速 度 。
		 每 回 合 半 径 %d 内 的 一 个 生 物 将 会 被 闪 电 击 中 ， 造 成 %0.2f 点 闪 电 伤 害 。
		 每 次 你 的 回 合 开 始 时 ， 如 果 自 从 上 个 回 合 结 束 你 受 到 超 过 20%% 最 大 生 命 值 的 伤 害， 你 将 获 得 %d%% 个 额 外 回 合 。
		 受 法 术 强 度 影 响 ， 伤 害 有 额 外 加 成 。]]):
		format(speed, range, damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)), turn)
	end,
}


return _M
