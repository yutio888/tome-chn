local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TURN_BACK_THE_CLOCK",
	name = "时光倒流",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local damagestat = t.getDamageStat(self, t)
		return ([[制 造 一 束 时 空 能 量 波 造 成 %0.2f 时 空 伤 害 并 降 低 目 标 %d 点 最 高 的 三 个 属 性， 持 续 3 回 合。 
		受 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(damDesc(self, DamageType.TEMPORAL, damage), damagestat)
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_FUGUE_OLD",
	name = "时空神游（旧）",
	info = function(self, t)
		local duration = t.getConfuseDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[将 %d 码 锥 形 半 径 范 围 内 敌 人 的 心 智 降 低 到 婴 儿 水 平， 混 乱 目 标 (%d%% 强 度) %d 回 合。 ]]):
		format(radius, t.getConfuseEfficency(self, t), duration)
	end,
}

registerTalentTranslation{
	id = "T_ASHES_TO_ASHES",
	name = "尘归尘",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[时 空 扭 曲 光 环 围 绕 着 你（ %d 码 半 径 范 围）， 在 3 回 合 内 对 范 围 所 有 目 标 造 成 %0.2f 累 积 时 空 伤 害。 效 果 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(radius, damDesc(self, DamageType.TEMPORAL, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_BODY_REVERSION",
	name = "返老还童",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[你 的 身 体 回 复 至 先 前 状 态， 治 疗 自 己 %0.2f 生 命 值 并 移 除 %d 个 物 理 状 态（ 增 益 状 态 或 负 面 状 态）。 
		 受 法 术 强 度 影 响， 生 命 回 复 按 比 例 加 成。]]):
		format(heal, count)
	end,
}

return _M
