local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DARK_WHISPERS",
	name = "黑暗低语",
	info = function(self, t)
		local dam = t.getDamage(self,t)
		local stat = t.getPowerLoss(self,t)
		local rad = self:getTalentRadius(t)
		return ([[令 半 径 %d 格 内 的 敌 人 的 心 灵 里 充 满 可 怕 的 幻 觉 和 疯 狂 的 低 语 ， 5 回 合 内 每 回 合 受 到 %0.2f 暗 影 伤 害 。 同 时 ， 该 效 果 将 降 低 其 物  理、  法 术 和精 神 强 度 %d 点 ， 该 效 果 可 叠 加 至 最 多 %d 点。
		技 能 效 果 受 法 术 强 度 加 成 。]]):
		format(rad, damDesc(self, DamageType.DARKNESS, dam), stat, stat*3)
	end,
}

registerTalentTranslation{
	id = "T_HIDEOUS_VISIONS",
	name = "惊骇幻象",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local dur = t.getDuration(self,t)
		local damage = t.getDamageReduction(self,t)
		return ([[每 次 敌 人 受 到 黑 暗 低 语 的 伤 害 时， 有 %d%% 几 率 在 视 野 内 产 生 持 续 %d 回 合 的 幻 象。 幻 象 不 能 行 动 ， 但 被 影 响 的 敌 人 在 幻 象 结 束 前 造 成 的 伤 害 降 低 %d%%。
		同 一 敌 人 同 时 只 能 产 生  一 个 幻 象。]]):
		format(chance, dur, damage)
	end,
}

registerTalentTranslation{
	id = "T_SANITY_WARP",
	name = "失智冲击",
	info = function(self, t)
		local dam = t.getDamage(self,t)
		local radius = self:getTalentRadius(t)
		return ([[每 当 幻 象 被 消 灭 时， 它 将 释 放 心 灵 冲 击 ，对 %d 格 内 的 敌 人 造 成 %0.2f 暗 影 伤 害 。 ]]):
		format(radius,damDesc(self, DamageType.DARKNESS, dam))
	end,
}

registerTalentTranslation{
	id = "T_CACOPHONY",
	name = "心灵尖啸",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dur = t.getDuration(self,t)
		local dam = t.getDamage(self,t)*100
		return ([[ 使 %d 格 内 的 黑 暗 低 语 音 量 提 升 %d 回 合 ， 达 到 震 耳 欲 聋 的 地 步， 额 外 施 加 一 层 低 语 效 果， 同 时 干 扰 一 切 思 考 能 力。
		被 黑 暗 低 语 影 响 的 目 标 产 生 幻 象 的 几 率 增 加 20%%， 每 次 受 到 黑 暗 低 语 或 失 智 冲 击 的 伤 害 时， 会 受 到 额 外 %d%% 时 空 伤 害。
		伤 害 受 法 术 强 度 加 成 。]]):format(rad, dur, dam)
	end,
}

return _M
