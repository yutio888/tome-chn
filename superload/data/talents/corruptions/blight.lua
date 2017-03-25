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
		return ([[用 腐 蚀 蠕 虫 感 染 目 标 6 回 合，降 低 目 标 %d%% 酸 性 枯 萎 抗 性 。
		效 果 结 束 或 者 目 标 死 亡 时 会 产 生 爆 炸 ， 在 4 码 半 径 内 造成 %d 酸 性 伤 害。同时，感 染 期 内 目 标 受 到 的 伤 害 将 以 %d%% 比 例 增 加 至 爆 炸 伤 害  中。
		伤 害 受 法 术 强 度 加 成 。]]):
		format(t.getResist(self,t), t.getDamage(self, t), t.getPercent(self, t))
	end,
}

registerTalentTranslation{
	id = "T_POISON_STORM",
	name = "剧毒风暴",
	info = function(self, t)
		local dam = damDesc(self, DamageType.BLIGHT, t.getDamage(self,t))
		local power, heal_factor, fail = t.getEffects(self, t)
		return ([[一 股 强 烈 的 剧 毒 风 暴 围 绕 着 施 法 者， 半 径 %d 持 续 %d 回 合。风 暴 内 的 生 物 将 进 入 中 毒 状 态 ，受 到 %0.2f 枯 萎 伤 害 并 中 毒 4 回 合 受 到 额 外 %0.2f 枯 萎 伤 害，有 %d%% 几 率 无 视 毒 素 免 疫 。
		技 能 等 级 2 时 有 几 率 触 发 阴 险 毒 素 效 果 ， 降 低 %d%% 治 疗 系 数。
		技 能 等 级 4 时 有 几 率 触 发 麻 痹 毒 素 效 果 ， 降 低 %d%% 伤 害。
		技 能 等 级 6 时 有 几 率 触 发 致 残 毒 素 效 果 ，%d%% 几 率 使 用 技 能 失 败。
		中 毒 几 率 在 可 能 的 毒 素 效 果 中 平 分。
		毒 素 伤 害 可 以 暴 击。
		伤 害 受 法 术 强 度 加 成。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t), dam/4, dam, t.getPoisonPenetration(self,t), heal_factor, power, fail)
	end,
}




return _M
