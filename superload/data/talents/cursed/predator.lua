local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MARK_PREY",
	name = "猎杀标记",
	info = function(self, t)
		local maxKillExperience = t.getMaxKillExperience(self, t)
		local subtypeDamageChange = t.getSubtypeDamageChange(self, t)
		local typeDamageChange = t.getTypeDamageChange(self, t)
		local hateDesc = ""
		if self:knowTalent(self.T_HATE_POOL) then
			local hateBonus = t.getHateBonus(self, t)
			hateDesc = ("无 论 当 前 仇 恨 回 复 值 为 多 少， 每 击 杀 一 个 被 标 记 的 亚 类 生 物 给 予 你 额 外 的 +%d 仇 恨 值 回 复。"):format(hateBonus)
		end
		return ([[标 记 某 个 敌 人 作 为 你 的 捕 猎 目 标， 使 攻 击 该 类 及 该 亚 类 的 生 物 时 获 得 额 外 加 成， 加 成 量 受 你 杀 死 该 标 记 类 生 物 获 得 的 经 验 值 加 成（ +0.25 主 类， +1 亚 类）， 当 你 增 加 %0.1f 经 验 值 时， 获 得 100%% 效 果 加 成。 攻 击 标 记 目 标 类 生 物 将 造 成 +%d%% 伤 害， 攻 击 标 记 目 标 亚 类 生 物 将 造 成 +%d%% 伤 害。 
		 每 增 加 一 个 技 能 点 减 少 达 到 100%% 效 果 加 成 的 经 验 需 求。 
		%s]]):format(maxKillExperience, typeDamageChange * 100, subtypeDamageChange * 100, hateDesc)
	end,
}

registerTalentTranslation{
	id = "T_ANATOMY",
	name = "解剖学",
	info = function(self, t)
		local subtypeAttackChange = t.getSubtypeAttackChange(self, t)
		local typeAttackChange = t.getTypeAttackChange(self, t)
		local subtypeStunChance = t.getSubtypeStunChance(self, t)
		return ([[你 对 捕 猎 目 标 的 了 解 使 你 的 攻 击 提 高 额 外 精 度， 对 标 记 类 目 标 获 得 +%d 命 中， 对 标 记 亚 类 目 标 获 得 +%d 命 中。 
		 每 次 近 战 攻 击 对 标 记 亚 类 生 物 有 %0.1f%% 概 率 震 慑 目 标 3 回 合。 
		 每 增 加 一 个 技 能 点 减 少 达 到 100%% 效 果 加 成 的 经 验 需 求。]]):format(typeAttackChange, subtypeAttackChange, subtypeStunChance)
	end,
}

registerTalentTranslation{
	id = "T_OUTMANEUVER",
	name = "运筹帷幄",
	info = function(self, t)
		local subtypeChance = t.getSubtypeChance(self, t)
		local typeChance = t.getTypeChance(self, t)
		local physicalResistChange = t.getPhysicalResistChange(self, t)
		local statReduction = t.getStatReduction(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 的 每 次 近 战 攻 击 有 一 定 概 率 触 发 运 筹 帷 幄， 降 低 目 标 的 物 理 抵 抗 %d%% 同 时 降 低 他 们 最 高 的 三 项 属 性 %d ， 对 标 记 类 生 物 有 %0.1f%% 概 率 触 发， 对 标 记 亚 类 生 物 有 %0.1f%% 概 率 触 发， 持 续 %d 回 合， 该 效 果 可 叠 加。 
		 每 增 加 一 个 技 能 点 减 少 达 到 100%% 效 果 加 成 的 经 验 需 求。]]):format(-physicalResistChange, statReduction, typeChance, subtypeChance, duration)
	end,
}

registerTalentTranslation{
	id = "T_MIMIC",
	name = "无相转生",
	info = function(self, t)
		local maxIncrease = t.getMaxIncrease(self, t)
		return ([[你 学 习 汲 取 目 标 的 力 量， 杀 死 该 亚 类 生 物 可 以 提 升 你 的 属 性 值 以 接 近 该 生 物 的 能 力（ 最 多 %d 总 属 性 点 数， 由 你 的 当 前 效 能 决 定）， 效 果 持 续 时 间 并 不 确 定， 且 只 有 最 近 杀 死 的 敌 人 获 得 的 效 果 有 效。 
		 每 增 加 一 个 技 能 点 减 少 达 到 100%% 效 果 加 成 的 经 验 需 求。]]):format(maxIncrease)
	end,
}



return _M
