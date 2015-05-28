local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BLOOD_SPRAY",
	name = "鲜血喷射",
	info = function(self, t)
		return ([[你 从 自 身 射 出 堕 落 之 血， 对 前 方 %d 码 半 径 锥 形 范 围 敌 人 造 成 %0.2f 枯 萎 伤 害。 
		 每 个 受 影 响 的 单 位 有 %d%% 概 率 感 染 1 种 随 机 疾 病， 受 到 %0.2f 枯 萎 伤 害， 并 且 随 机 弱 化 目 标 体 质、 力 量 和 敏 捷 中 的 一 项 属 性， 持 续 6 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 10, 190)), t.getChance(self, t), damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 10, 220)))
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_GRASP",
	name = "鲜血支配",
	info = function(self, t)
		return ([[释 放 一 个 堕 落 血 球， 造 成 %0.2f 枯 萎 伤 害 并 恢 复 你 一 半 伤 害 值 的 生 命。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 10, 290)))
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_BOIL",
	name = "鲜血沸腾",
	info = function(self, t)
		return ([[使 你 周 围 %d 码 半 径 范 围 内 的 敌 人 鲜 血 沸 腾， 造 成 %0.2f 枯 萎 伤 害 并 减 少 目 标 20%% 速 度。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 28, 190)))
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_FURY",
	name = "鲜血狂怒",
	info = function(self, t)
		return ([[专 注 于 你 带 来 的 腐 蚀， 提 高 你 %d%% 法 术 暴 击 率。 
		 每 当 你 的 法 术 打 出 暴 击 时， 你 进 入 嗜 血 状 态 5 回 合， 增 加 你 %d%% 枯 萎 和 酸 性 伤 害。 
		 受 法 术 强 度 影 响， 暴 击 率 和 伤 害 有 额 外 加 成。]]):
		format(self:combatTalentSpellDamage(t, 10, 14), self:combatTalentSpellDamage(t, 10, 30))
	end,
}



return _M
