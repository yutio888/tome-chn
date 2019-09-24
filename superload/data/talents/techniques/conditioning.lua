local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_VITALITY",
	name = "活力",
	info = function(self, t)
		local wounds = t.getWoundReduction(self, t) * 100
		local baseheal, healpct = t.getHealValues(self, t)
		local duration = t.getDuration(self, t)
		local totalheal = baseheal + self.max_life*healpct/duration
		return ([[你 受 中 毒、 疾 病 和 创 伤 的 影 响 较 小， 减 少 %d%% 此 类 效 果 的 持 续 时 间。 
		此 外 在 生 命值 低 于 50%% 时 ，你的生命回复将会增加%0.1f ，持 续 %d 回 合 ，共回复%d生命值， 但 每 隔 %d 回 合 才 能 触 发 一 次。
		受 体 质 影 响， 生 命 回 复 有 额 外 加 成。]]):
		format(wounds, baseheal, duration, baseheal*duration, self:getTalentCooldown(t))
	end,
}

registerTalentTranslation{
	id = "T_UNFLINCHING_RESOLVE",
	name = "顽强意志",
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[你 学 会 从 负 面 状 态 中 快 速 恢 复。 
		每 回 合 你 有 %d%% 几 率 从 震 慑 效 果 中 恢 复。 
		在 等 级 2 时， 也 可 以 从 致 盲 效 果 中 恢 复。 
		在 等 级 3 时， 也 可 以 从 混 乱 效 果 中 恢 复。 
		在 等 级 4 时， 也 可 以 从 定 身 效 果 中 恢 复。 
		在 等 级 5 时， 也 可 以 从 减 速 或 流 血 效 果 中 恢 复。 
		每 回 合 你 只 能 摆 脱 1 种 状 态。 
		受 体 质 影 响， 恢 复 概 率 按 比 例 加 成。]]):
		format(chance)
	end,
}

registerTalentTranslation{
	id = "T_DAUNTING_PRESENCE",
	name = "望而生畏",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local penalty = t.getPenalty(self, t)
		return ([[敌 人 因 你 的存在而恐 惧。 
		半径%d范围内的敌人的物理强度，精神强度和法术强度会降低%d。
		受 物 理 强 度 影 响， 威 胁 效 果 有 加 成。 ]]):
		format(radius, penalty)
	end,
}

registerTalentTranslation{
	id = "T_ADRENALINE_SURGE",
	name = "肾上腺素",
	info = function(self, t)
		local attack_power = t.getAttackPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 激 活 肾 上 腺 素 来 增 加 %d 物 理 强 度 持 续 %d 回 合。 
		此 技 能 激 活 时， 你 可 以 不 知 疲 倦 地 战 斗， 若 体 力 为 0 ， 可 继 续 使 用 消 耗 类 技 能， 代 价 为 消 耗 生 命。 
		受 体 质 影 响， 物 理 强 度 有 额 外 加 成。 
		使 用 本 技 能 不 会 消 耗 额 外 回 合。]]):
		format(attack_power, duration)
	end,
}


return _M
