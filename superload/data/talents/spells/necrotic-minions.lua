local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_NECROTIC_AURA",
	name = "死灵光环",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local decay = t.getDecay(self, t)
		return ([[产 生 一 个 死 灵 光 环， 维 持 你 亡 灵 随 从 的 生 存， %d 码 有 效 范 围。 在 光 环 以 外 的 随 从 每 回 合 减 少 %d%% 生 命。 
		 所 有 在 你 光 环 中 被 杀 死 的 敌 人 灵 魂 可 以 吸 收 以 召 唤 随 从。 
		 食 尸 鬼 的 呕 吐 同 时 也 能 治 疗 你， 即 使 你 不 是 不 死 族。]]):
		format(radius, decay)
	end,
}

registerTalentTranslation{
	id = "T_CREATE_MINIONS",
	name = "亡灵召唤",
	info = function(self, t)
		local nb = t.getMax(self, t)
		local lev = t.getLevel(self, t)
		local mm = self:knowTalent(self.T_MINION_MASTERY) and " (Minion Mastery effects included)" or ""
		return ([[通 过 你 的 亡 灵 光 环 释 放 强 烈 的 不 死 能 量。 在 你 的 光 环 里， 每 有 1 个 刚 死 亡 的 目 标， 你 召 唤 1 个 亡 灵 随 从（ 最 多 %d 个）。 
		 亡 灵 随 从 在 光 环 边 缘 按 照 锥 形 分 布。 
		 单 位 等 级 为 你 的 等 级 %+d.
		 每 个 单 位 有 概 率 进 阶 为 %s:%s ]]):
		format(nb, lev, mm, t.MinionChancesDesc(self, t)
		:gsub("Degenerated skeleton warrior","堕 落 骷 髅 战 士"):gsub("Skeleton warrior","骷 髅 战 士"):gsub("Armoured skeleton warrior","装 甲 骷 髅 战 士")
		:gsub("Skeleton archer","骷 髅 弓 箭 手"):gsub("Skeleton master archer","精 英 骷 髅 弓 箭 手"):gsub("Skeleton mage","骷 髅 法 师")
		:gsub("Ghoul","食 尸 鬼"):gsub("Ghast","妖 鬼"):gsub("king","王"))
	end,
}

registerTalentTranslation{
	id = "T_AURA_MASTERY",
	name = "光环掌握",
	info = function(self, t)
		return ([[随 着 你 逐 渐 强 大， 黑 暗 能 量 的 影 响 范 围 增 加。 
		 增 加 亡 灵 光 环 %d 码 半 径， 并 减 少 光 环 范 围 外 亡 灵 随 从 每 回 合 掉 血 量 %d%% 。
		 技 能 等 级 3 后，光 环 内 亡 灵 随 从 死 亡 时 有 25%% 几 率 返 还 灵 魂，若 其 转 换 为 鬼 火 ， 则 在 鬼 火 爆 炸 时 返 还 。.]]):
		format(math.floor(t.getbonusRadius(self, t)), math.min(7, self:getTalentLevelRaw(t)))
	end,
}

registerTalentTranslation{
	id = "T_SURGE_OF_UNDEATH",
	name = "不死狂潮",
	info = function(self, t)
		return ([[一 股 强 大 的 能 量 灌 输 入 你 的 所 有 亡 灵 随 从。 
		 增 加 它 们 的 物 理 强 度、 法 术 强 度 和 命 中 %d 点， %d 点 护 甲 穿 透， %d 暴 击 几 率， 持 续 6 回 合。 
		 受 法 术 强 度 影 响， 此 效 果 有 额 外 加 成。]]):
		format(t.getPower(self, t), t.getAPR(self, t), t.getCrit(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DARK_EMPATHY",
	name = "黑暗共享",
	info = function(self, t)
		return ([[你 和 你 的 亡 灵 随 从 分 享 你 的 能 量， 随 从 获 得 你 的 抵 抗 和 豁 免 的 %d%% 。 
		 此 外， 所 有 随 从 对 你 和 其 他 随 从 造 成 的 伤 害 减 少 %d%% 。 
		 受 法 术 强 度 影 响， 此 效 果 有 额 外 加 成。]]):
		format(t.getPerc(self, t), self:getTalentLevelRaw(t) * 20)
	end,
}


return _M
