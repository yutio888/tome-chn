local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CORRUPTED_STRENGTH",
	name = "堕落力量",
	info = function(self, t)
		return ([[允 许 你 双 持 单 手 武 器 并 使 副 手 武 器 伤 害 增 加 至 %d%% 。 
		 同 时 每 释 放 1 个 法 术（ 消 耗 1 回 合） 会 给 予 近 战 范 围 内 的 1 个 随 机 目 标 一 次 附 加 攻 击， 造 成 %d%% 枯 萎 伤 害。]]):
		 format(100*t.getoffmult(self,t), 100 * self:combatTalentWeaponDamage(t, 0.2, 0.7))
		end,
}

registerTalentTranslation{
	id = "T_BLOODLUST",
	name = "嗜血杀戮",
	info = function(self, t)
		local SPbonus = t.getSpellpower(self, t)
		return ([[每 当 你 使 用 近 战 武 器 击 中 一 个 目 标 ，你 进 入 嗜 血 状 态 ，增 加 你 的 法 术 强 度  %0.1f  。
		 这 一 效 果 最 多 叠 加  10  层 ，共 获 得  %d  法 术 强 度 。
		 嗜 血 状 态 持 续  3  回 合 。]]):
		format(SPbonus, SPbonus*10)
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
