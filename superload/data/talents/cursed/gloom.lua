local _M = loadPrevious(...)

local function gloomTalentsMindpower(self)
	return self:combatScale(self:getTalentLevel(self.T_GLOOM) + self:getTalentLevel(self.T_WEAKNESS) + self:getTalentLevel(self.T_DISMAY) + self:getTalentLevel(self.T_SANCTUARY), 1, 1, 20, 20, 0.75)
end

registerTalentTranslation{
	id = "T_GLOOM",
	name = "黑暗光环",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[1 个 3 码 半 径 范 围 的 可 怕 黑 暗 光 环 围 绕 你 , 影 响 附 近 的 敌 人。 
		 光 环 内 的 每 一 个 目 标 每 回 合 必 须 与 你 的 精 神 强 度 进 行 豁 免 鉴 定， 未 通 过 鉴 定 则 有 %d%% 概 率 被 减 速、 震 慑、 混 乱， 持 续 %d 回 合。 
		 这 个 能 力 是 与 生 俱 来 的， 激 活 或 停 止 不 消 耗 任 何 能 量， 每 增 加 一 点 技 能 点 可 增 加 黑 暗 光 环 系 精 神 强 度（ 当 前： %+d ）。]]):format(chance, duration, mindpowerChange)
	end,
}

registerTalentTranslation{
	id = "T_WEAKNESS",
	name = "黑暗衰竭",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		local incDamageChange = t.getIncDamageChange(self, t)
		local hateBonus = t.getHateBonus(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[在 黑 暗 光 环 里 的 每 一 个 目 标 每 回 合 必 须 与 你 的 精 神 强 度 进 行 豁 免 鉴 定， 未 通 过 鉴 定 则 有 %d%% 概 率 被 恐 惧 而 虚 弱 持 续 %d 回 合， 降 低 %d%% 伤 害， 你 对 被 削 弱 目 标 的 首 次 近 战 攻 击 能 获 得 %d 点 仇 恨 值。 
		 每 增 加 一 点 技 能 点 可 增 加 黑 暗 光 环 系 精 神 强 度（ 当 前： %+d ）。]]):format(chance, duration, -incDamageChange, hateBonus, mindpowerChange)
	end,
}

registerTalentTranslation{
	id = "T_DISMAY",
	name = "黑暗痛苦",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[在 黑 暗 光 环 里 的 每 一 个 目 标 每 回 合 必 须 与 你 的 精 神 强 度 进 行 豁 免 鉴 定， 未 通 过 鉴 定 则 有 %0.1f%% 概 率 受 到 黑 暗 痛 苦 持 续 %d 回 合， 你 对 受 黑 暗 痛 苦 折 磨 的 目 标 进 行 的 首 次 近 战 攻 击 必 定 暴 击。 
		 每 增 加 一 点 技 能 点 可 增 加 黑 暗 光 环 系 精 神 强 度（ 当 前： %+d ）。]]):format(chance, duration, mindpowerChange)
	end,
}

registerTalentTranslation{
	id = "T_SANCTUARY",
	name = "庇护光环",
	info = function(self, t)
		local damageChange = t.getDamageChange(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[你 的 黑 暗 光 环 成 为 独 立 于 外 界 的 避 难 所， 任 何 光 环 外 的 目 标 对 你 的 伤 害 降 低 %d%% 。 
		 每 增 加 一 点 技 能 点 可 增 加 黑 暗 光 环 系 精 神 强 度（ 当 前： %+d ）。]]):format(-damageChange, mindpowerChange)
	end,
}



return _M
