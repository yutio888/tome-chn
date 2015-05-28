local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HACK_N_BACK",
	name = "燕回斩",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local dist = t.getDist(self, t)
		return ([[你 对 目 标 造 成 %d%% 伤 害， 分 散 它 的 注 意 力 并 往 回 跳 %d 码。]]):
		format(100 * damage, dist)
	end,
}

registerTalentTranslation{
	id = "T_MOBILE_DEFENCE",
	name = "轻装防御",
	info = function(self, t)
		return ([[当 你 装 备 皮 甲 或 轻 甲 时， 你 会 增 加 %d%% 近 身 闪 避 和 %d%% 护 甲 韧 性。]]):
		format(t.getDef(self, t) * 100, t.getHardiness(self, t))
	end,
}

registerTalentTranslation{
	id = "T_LIGHT_OF_FOOT",
	name = "踏雪无痕",
	info = function(self, t)
		return ([[你 的 步 伐 很 轻 快， 使 你 能 更 好 的 适 应 盔 甲 的 重 量。 每 移 动 一 步 你 可 以 回 复 %0.2f 体 力 并 且 你 的 负 担 永 久 减 少 %0.1f%% 。 
		在 等 级 3 时 你 的 脚 步 非 常 轻 快 以 至 于 你 不 会 触 发 压 力 式 陷 阱。]]):
		format(self:getTalentLevelRaw(t) * 0.2, t.getFatigue(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STRIDER",
	name = "凌波微步",
	info = function(self, t)
		return ([[你 在 敌 人 周 围 跳 起 华 丽 的 舞 蹈， 增 加 %d%% 移 动 速 度 并 减 少 燕 回 斩、 冲 锋、 逃 脱 和 回 避 技 能 %d 回 合。]]):
		format(t.incspeed(self, t)*100,t.CDreduce(self, t))
	end,
}


return _M
