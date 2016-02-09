local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BLASTWAVE",
	name = "火焰新星",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[从 你 身 上 释 放 出 一 波 %d 码 半 径 范 围 的 火 焰， 击 退 范 围 内 所 有 目 标 并 使 它 们 进 入 3 回 合 灼 烧 状 态， 共 造 成 %0.2f 火 焰 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(radius, damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_BURNING_WAKE",
	name = "无尽之炎",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 的 火 球 术、 火 焰 冲 击、 爆 裂 火 球 和 火 焰 新 星 都 会 在 地 上 留 下 燃 烧 的 火 焰， 每 回 合 对 经 过 者 造 成 %0.2f 火 焰 伤 害， 持 续 4 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_CLEANSING_FLAMES",
	name = "净化之焰",
	info = function(self, t)
		return ([[当 你 的 无 尽 之 炎 激 活 时， 你 的 地 狱 火 和 无 尽 之 炎 均 有 %d%% 概 率 净 化 目 标 身 上 一 种 状 态。（ 物 理， 法 术， 诅 咒 或 巫 术） 
		 如 果 目 标 是 敌 人， 则 净 化 其 增 益 状 态。 
		 如 果 目 标 时 友 方 单 位， 则 净 化 负 面 状 态（ 仍 然 有 燃 烧 效 果）。]]):format(t.getChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WILDFIRE",
	name = "野火燎原",
	info = function(self, t)
		local damageinc = t.getFireDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local selfres = t.getResistSelf(self, t)
		return ([[使 身 上 缠 绕 火 焰， 增 加 %d%% 所 有 火 系 伤 害 并 无 视 目 标 %d%% 火 焰 抵 抗。 
		 同 时， 减 少 %d%% 对 自 己 造 成 的 火 焰 伤 害。]])
		:format(damageinc, ressistpen, selfres)
	end,
}


return _M
