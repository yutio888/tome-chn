local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PROPHECY",
	name = "预言",
	info = function(self, t)
		local mcd = t.getMadnessCooldown(self,t)*100
		local rdam = t.getRuinDamage(self,t)
		local tchance = t.getTreasonChance(self,t)
		--local tdam = t.getTreasonDamage(self,t)
		return ([[对 目 标 释 放 熵 能 力 量 ，你 预 言 了 它 无 可 避 免 的 末 日 。 随 着 技 能 等 级 提 升 ， 你 能 解 锁 更 多 预 言 。 同 一 目 标 不 能 同 时 处 于 两 种 预 言 下 。		
技能等级 1： 疯 狂 预 言。 增 加 %d%% 技 能 冷 却 时 间。
技能等级 3： 毁 灭 预 言。 当 生 命 值 滑 落 至 最 大 生 命 的 75%%，50%% 或 25%% 下 时 ，造 成 %d 伤 害 。
技能等级 5： 背 叛 预 言。 每 回 合 有 %d%% 几 率 攻 击 友 方 单 位 或 自 身。]]):
		format(mcd, rdam, tchance)
	end,
}

-- These may need to be implemented differently to avoid talent level scaling bugs
registerTalentTranslation{
	id = "T_PROPHECY_OF_MADNESS",
	name = "疯狂预言",
	info = function(self, t)
		local cd = t.getCooldown(self,t)*100
		return ([[对 目 标 施 加 疯 狂 预 言， 增 加 %d%% 技 能 冷 却 时 间， 持 续 6 回 合。 ]]):format(cd)
	end,
}

registerTalentTranslation{
	id = "T_PROPHECY_OF_RUIN",
	name = "毁灭预言",
	info = function(self, t)
		local dam = t.getDamage(self,t)
		return ([[对 目 标 施 加 毁 灭 预 言，  持 续 6 回 合。
		当 生 命 值 滑 落 至 最 大 生 命 的 75%%，50%% 或 25%% 下 时 ，造 成 %d 暗 影 伤 害 。
		伤 害 受 法 术 强 度 加 成 。]]):format(dam)
	end,
}

registerTalentTranslation{
	id = "T_PROPHECY_OF_TREASON",
	name = "背叛预言",
	info = function(self, t)
		local chance = t.getChance(self,t)
		return ([[对 目 标 施 加 背 叛 预 言，  持 续 6 回 合。每 回 合 有 %d%% 几 率 攻 击 友 方 单 位 或 自 身。]]):format(chance)
	end,
}

registerTalentTranslation{
	id = "T_GRAND_ORATION",
	name = "隆重演说",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"		
		return ([[你 隆 重 地 宣 读 某 种 预 言， 令 其 在 周 围 %d 格 内 传 播 。
		同 一 种 预 言 只 能 以 一 种 方 式 进 行 演 说， 双 重 诅 咒 或 者 天 启 。
		
		当 前 预 言 : %s]]):
		format(rad, talent)
	end,
}

registerTalentTranslation{
	id = "T_TWOFOLD_CURSE",
	name = "双重诅咒",
	info = function(self, t)
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"		
		return ([[对 你 的 听 众 施 加 双 重 诅 咒。 每 当 你 施 加 其 他 预 言 时 ， 你 选 择 的 预 言 将 同 时 施 加 给 主 要 目 标。 
		同 一 种 预 言 只 能 以 一 种 方 式 进 行 演 说， 双 重 诅 咒 或 者 天 启 。
		当 前 预 言 : %s]]):
		format(self:getTalentLevel(t), talent)
	end,
}

registerTalentTranslation{
	id = "T_REVELATION",
	name = "天启",
	info = function(self, t)
		local madness = t.getMadness(self,t)
		local ruin = t.getRuin(self,t)
		local treason = t.getTreason(self,t)
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[当 你 宣 读 预 言 时 ， 来 自 虚 空 的 回 响 将 指 引 你 带 来 敌 人 的 末 日 。 你 选 择 的 预 言 将 提 供 1 0 回 合 的 加 成。
		疯 狂 预 言 ： 每 次 目 标 使 用 技 能 时 ，你 的 一 个 技 能 的 冷 却 时 间 将 减 少 %d 。
		毁 灭 预 言 ： 每 次 目 标 受 到 伤 害 时， 你 回 复 %d%% 伤 害 值。
		背 叛 预 言 :  你 受 到 的 %d%% 伤 害 将 转 移 至 周 围 随 机 目 标。
		
		同 一 种 预 言 只 能 以 一 种 方 式 进 行 演 说， 双 重 诅 咒 或 者 天 启 。
		当 前 预 言 : %s]]):
		format(madness, ruin, treason, talent)
	end,
}

return _M
