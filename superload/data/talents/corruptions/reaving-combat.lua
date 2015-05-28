local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CORRUPTED_STRENGTH",
	name = "堕落力量",
	info = function(self, t)
		return ([[允 许 你 双 持 单 手 武 器 并 使 副 手 武 器 伤 害 增 加 至 %d%% 。 
		 同 时 每 释 放 1 个 法 术（ 消 耗 1 回 合） 会 给 予 近 战 范 围 内 的 1 个 随 机 目 标 一 次 附 加 攻 击， 造 成 %d%% 枯 萎 伤 害。]]):
		format(100*t.getoffmult(self,t), 100 * self:combatTalentWeaponDamage(t, 0.5, 1.1))
	end,
}

registerTalentTranslation{
	id = "T_BLOODLUST",
	name = "嗜血杀戮",
	info = function(self, t)
		local SPbonus, maxDur = t.getParams(self, t)
		return ([[当 你 对 敌 人 造 成 伤 害 时， 你 进 入 嗜 血 状 态， 每 伤 害 1 个 目 标 增 加 1 点 法 术 强 度，并 延 长 现 有 状 态 1 回 合。  
		 此 技 能 每 回 合 最 多 使 你 增 加 共 计 +%d 点 法 术 强 度，且 总 计 最 多 增 加 +%d 点 法 术 强 度。
		 嗜 血 状 态 持 续 %d 回 合， 每 经 过 一 个 未 造 成 伤 害 的 回 合， 法 术 强 度 加 成 下 降 %0.1f%% 。]]):
		format(SPbonus, SPbonus*6, maxDur, 100/maxDur)
	end,
}

registerTalentTranslation{
	id = "T_CARRIER",
	name = "携带者",
	info = function(self, t)
		return ([[你 增 加 %d%% 疾 病 抵 抗 并 有 %d%% 概 率 在 近 战 时 散 播 你 目 标 身 上 现 有 的 疾 病。]]):
		format(t.getDiseaseImmune(self, t)*100, t.getDiseaseSpread(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ACID_BLOOD",
	name = "酸性血液",
	info = function(self, t)
		return ([[你 的 血 液 变 成 酸 性 混 合 物。 当 你 受 伤 害 时， 攻 击 者 会 受 到 酸 性 溅 射。 
		 每 回 合 溅 射 会 造 成 %0.2f 酸 性 伤 害， 持 续 5 回 合。 
		 同 时 减 少 攻 击 者 %d 点 命 中。 
		 在 等 级 3 时， 酸 性 溅 射 会 减 少 目 标 %d 点 护 甲 持 续 5 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ACID, self:combatTalentSpellDamage(t, 5, 30)), self:combatTalentSpellDamage(t, 15, 35), self:combatTalentSpellDamage(t, 15, 40))
	end,
}



return _M
