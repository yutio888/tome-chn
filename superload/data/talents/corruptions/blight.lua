local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DARK_RITUAL",
	name = "黑暗仪式",
	info = function(self, t)
		return ([[增 加 %d%% 法 术 暴 击 倍 率。 
		 受 法 术 强 度 影 响， 倍 率 有 额 外 加 成。]]):
		format(self:combatTalentSpellDamage(t, 20, 60))
	end,
}

registerTalentTranslation{
	id = "T_CORRUPTED_NEGATION",
	name = "能量腐蚀",
	info = function(self, t)
		return ([[在 3 码 球 形 范 围 内 制 造 一 个 堕 落 能 量 球， 造 成 %0.2f 枯 萎 伤 害 并 移 除 范 围 内 任 意 怪 物 至 多 %d 种 魔 法 或 物 理 效 果。 
		 每 除 去 一 个 效 果 时， 基 于 法 术 豁 免， 目 标 都 有 一 定 概 率 抵 抗。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 28, 120)), t.getRemoveCount(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CORROSIVE_WORM",
	name = "腐蚀蠕虫",
	info = function(self, t)
		return ([[用 腐 蚀 蠕 虫 感 染 目 标， 每 回 合 造 成 %0.2f 酸 性 伤 害， 持 续 10 回 合。 
		 如 果 蠕 虫 在 目 标 体 内 时， 目 标 死 亡， 则 会 产 生 酸 性 爆 炸， 在 4 码 半 径 范 围 内 造 成 %0.2f 酸 性 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成， 并 且 该 技 能 可 暴 击。]]):
		format(damDesc(self, DamageType.ACID, self:combatTalentSpellDamage(t, 10, 60)), damDesc(self, DamageType.ACID, self:combatTalentSpellDamage(t, 10, 230)))
	end,
}

registerTalentTranslation{
	id = "T_POISON_STORM",
	name = "剧毒风暴",
	info = function(self, t)
		return ([[一 股 强 烈 的 剧 毒 风 暴 围 绕 着 施 法 者， 半 径 %d 持 续 %d 回 合。风 暴 内 的 生 物 将 进 入 中 毒 状 态 ，受 到 共 计 %0.2f 的 自 然 伤 害。 
		 毒 性 是 可 以 叠 加 的， 它 们 在 剧 毒 风 暴 里 待 的 时 间 越 长， 它 们 受 到 的 毒 素 伤 害 越 高。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成， 并 且 可 暴 击。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t), damDesc(self, DamageType.NATURE, self:combatTalentSpellDamage(t, 12, 130)))
	end,
}




return _M
