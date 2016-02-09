local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKIRMISHER_BUCKLER_EXPERTISE",
	name = "盾牌训练",
	info = function(self, t)
		local block = t.chance(self, t)
		local armor = t.getHardiness(self, t)
		return ([[允 许 你 装 备 盾 牌， 使 用 灵 巧 作 为 属 性 需 求。
		当 你 受 到 近 战 攻 击，你 有 %d%% 的 几 率 用 盾 牌 使 这 次 攻 击 偏 斜， 并 完 全 躲 避 它。
		受 到 灵 巧 影 响， 偏 斜 几 率 有 加 成。]])
			:format(block, armor)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_BASH_AND_SMASH",
	name = "击退射击",
	info = function(self, t)
		local shieldMult = t.getShieldMult(self, t) * 100
		local tiles = t.getDist(self, t)
		local slingMult = t.getSlingMult(self, t) * 100
		return ([[用 盾 牌 重 击 近 战 范 围 内 的 一 名 敌 人 （ 当 技 能 等 级 在 5 级 或 更 高 时 重 击 2 次 ）， 造 成 %d%% 伤 害 并 击 退 %d 格。 紧 接 着 用 投 石 索 发 动 一 次 致 命 的 攻 击， 造 成 %d%% 伤 害。 
		盾 牌 攻 击 使 用 敏 捷 取 代 力 量 来 计 算 盾 牌 伤 害 加 成。]])
		:format(shieldMult, tiles, slingMult)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_BUCKLER_MASTERY",
	name = "格挡大师",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local range = t.getRange(self, t)
		return ([[当 你 被 抛 射 物 攻 击 时， 不 论 是 否 为 物 理 类 型， 你 有 %d%% 的 几 率 使 其 偏 斜 最 多 %d 格。
		技 能 等 级 5 时 ， 你 的 击 退 射 击 必 定 暴 击。]])
			:format(chance, range)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_COUNTER_SHOT",
	name = "以牙还牙",
	info = function(self, t)
		local mult = t.getMult(self, t) * 100
		local blocks = t.getBlocks(self, t)
		
		return ([[每 当 你 的 格 挡 专 家 或 者 格 挡 大 师 技 能 挡 住 攻 击 时， 你 立 刻 使 用 投 石 索 发 动 一 次 伤 害 %d%% 的 反 击。 每 回 合 最 多 只 能 发 动 %d 次 反 击。
			]])
			:format(mult, blocks)
	end,
}


return _M
