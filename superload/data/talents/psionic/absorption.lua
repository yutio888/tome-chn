local _M = loadPrevious(...)

local function getShieldStrength(self, t)
	--return math.max(0, self:combatMindpower())
	return self:combatTalentMindDamage(t, 20, 100)
end

local function getEfficiency(self, t)
	return self:combatTalentLimit(t, 100, 20, 55)/100 -- Limit to <100%
end

local function maxPsiAbsorb(self, t) -- Max psi/turn to prevent runaway psi gains (solipsist randbosses)
	return 2 + self:combatTalentScale(t, 0.3, 1)
end

local function shieldMastery(self, t)
	return 100-self:combatTalentMindDamage(t, 40, 50)
end

registerTalentTranslation{
	id = "T_KINETIC_SHIELD",
	name = "动能护盾",
	info = function(self, t)
		local s_str = getShieldStrength(self, t)
		local absorb = 100*getEfficiency(self,t)
		return ([[用 护 盾 环 绕 自 己 ，吸 收  %d%%  物 理 、酸 性 、自 然 、时 空 伤 害 ，每 次 最 多 吸 收 %d 伤 害 。
		每 次 你 的 护 盾 吸 收 伤 害 时，将 部 分 伤 害 转 化 为 能 量 ，获 得 两 点 超 能 力 值 ，每 吸 收 %0.1f 点 伤 害 额 外 增 加 一 点 超 能 力 值 ，每 回 合 最 多 增 加 %0.1f 点 超 能 力 值 。
		等 级 3 时 ， 当 你 关 掉 护 盾 ，前 3 回 合 内 吸 收 的 全 部 伤 害 值 的 两 倍 将 被 释 放 成 为 一 个 完 整 的 超 能 力 护 盾 （吸 收 完 整 伤 害 ）
		护 盾 的 吸 收 值 和 获 得 超 能 力 值 的 效 率 随 精 神 强 度 增 强 。]]):
		format(absorb, s_str, shieldMastery(self, t), maxPsiAbsorb(self,t))
	end,
}

registerTalentTranslation{
	id = "T_THERMAL_SHIELD",
	name = "热能护盾",
	info = function(self, t)
		local s_str = getShieldStrength(self, t)
		local absorb = 100*getEfficiency(self,t)
		return ([[用 护 盾 环 绕 自 己 ，吸 收  %d%%  火 焰 、寒 冷 、光 系 、奥 术 伤 害 ，每 次 最 多 吸 收 %d 伤 害 。
		每 次 你 的 护 盾 吸 收 伤 害 时，将 部 分 伤 害 转 化 为 能 量 ，获 得 两 点 超 能 力 值 ，每 吸 收 %0.1f 点 伤 害 额 外 增 加 一 点 超 能 力 值 ，每 回 合 最 多 增 加 %0.1f 点 超 能 力 值 。
		等 级 3 时 ， 当 你 关 掉 护 盾 ，前 3 回 合 内 吸 收 的 全 部 伤 害 值 的 两 倍 将 被 释 放 成 为 一 个 完 整 的 超 能 力 护 盾 （吸 收 完 整 伤 害 ）
		护 盾 的 吸 收 值 和 获 得 超 能 力 值 的 效 率 随 精 神 强 度 增 强 。]]):
		format(absorb, s_str, shieldMastery(self, t), maxPsiAbsorb(self,t))
	end,
}

registerTalentTranslation{
	id = "T_CHARGED_SHIELD",
	name = "电能护盾",
	info = function(self, t)
		local s_str = getShieldStrength(self, t)
		local absorb = 100*getEfficiency(self,t)
		return ([[用 护 盾 环 绕 自 己 ，吸 收  %d%%  闪 电 、枯 萎 、暗 影 、精 神 伤 害  , 每 次 最 多 吸 收 %d 伤 害 。
每 次 你 的 护 盾 吸 收 伤 害 ，将 其 部 分 转 化 为 能 量 ，获 得 两 点 能 量 ，每 吸 收 %0.1f 点 伤 害 额 外 增 加 一 点 能 量 ，每 回 合 最 多 增 加 %0.1f 点 能 量 。
等 级 3 时 ， 当 你 关 掉 护 盾 ，前 3 回 合 内 吸 收 的 全 部 伤 害 两 倍 将 被 释 放 成 为 一 个 完 整 的 超 能 力 护 盾 （吸 收 完 整 伤 害 ）
护 盾 的 吸 收 值 和 获 得 能 量 的 效 率 随 精 神 强 度 增 强 .]]):
		format(absorb, s_str, shieldMastery(self, t), maxPsiAbsorb(self,t))
	end,
}

registerTalentTranslation{
	id = "T_FORCEFIELD",
	name = "超能力场",
	info = function(self, t)
		return ([[用 力 场 环 绕 自 己 ，减 少 受 到 的 所 有 伤 害 %d%%
		维 持 这 样 的 护 盾 代 价 非 常 昂 贵 ，开 启 时 每 回 合 叠 加 消 耗 5%% 你 的 最 大 超 能 值 ，第 二 回 合 将 消 耗 10%% ，依 次 递 增 。]]):
		format(t.getResist(self,t))
	end,
}


return _M
