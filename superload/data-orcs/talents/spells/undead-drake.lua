local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAZE",
	name = "夷为平地",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 在 死 亡 中 狂 欢， 吞 噬 你 受 害 者 们 的 灵 魂。 每 当 你 对 一 个 目 标 造 成 伤 害 时， 你 造 成 %0.2f 额 外 暗 影 伤 害。
		除 此 之 外， 每 当 你 杀 死 敌 人 时 你 获 得 %d 个 灵 魂。
		伤 害 将 会 随 你 法 术 强 度 和 心 灵 强 度 中 较 高 者 变 化 ， 且 每 回 合 最 多 触 发 十 五 次 。 ]]):
		format(damDesc(self, DamageType.DARKNESS, damage), t.soulBonus(self,t))
	end,}

registerTalentTranslation{
	id = "T_INFECTIOUS_MIASMA",
	name = "疫毒瘴气",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[在 目 标 区 域 释 放 一 个 致 命 的 瘴 气 云 团， 对 其 中 所 有 的 目 标 造 成 %0.2f 暗 影 伤 害 并 有 20%% 几 率 使 其 感 染 一 个 持 续 %d 回 合 的 疾 病。 疾 病 将 造 成 枯 萎 伤 害 并 降 低 体 质， 力 量， 或 敏 捷。
		伤 害 将 会 随 你 法 术 强 度 和 心 灵 强 度 中 较 高 者 变 化。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), t.getBaneDur(self,t))
	end,}

registerTalentTranslation{
	id = "T_VAMPIRIC_SURGE",
	name = "吸血狂潮",
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)
		return ([[你 激 发 一 波 吸 血 能 量， 持 续 %d 回 合。
		在 状 态 持 续 中 你 造 成 的 所 有 伤 害 的 %d%% 都 将 转 换 为 你 的 生 命。]]):
		format(dur, power)
	end,}


registerTalentTranslation{
	id = "T_NECROTIC_BREATH",
	name = "死灵吐息",
	info = function(self, t)
		return ([[你 向 半 径 %d 的 锥 形 内 喷 出 致 死 瘴 气。 任 何 被 喷 到 的 目 标 将 在 4  会 合 内 受 到 %0.2f 暗 影 伤 害 并 被 混 乱 灾 祸 或 致 盲 灾 祸 影 响。
		伤 害 将 会 随 着 你 的 魔 力 增 长， 并 且 暴 击 率 基 于 你 的 魔 法 暴 击 率。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.DARKNESS, self:combatTalentStatDamage(t, "mag", 30, 550)))
	end,}
return _M