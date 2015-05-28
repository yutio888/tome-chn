local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_UNDEAD_EXPLOSION",
	name = "亡灵爆炸",
	info = function(self, t)
		return ([[亡 灵 随 从 只 是 工 具。 你 可 以 残 忍 地 引 爆 它 们。 
		 使 目 标 单 位 爆 炸 并 造 成 枯 萎 伤 害， 伤 害 为 它 最 大 生 命 值 的 %d%% ,半 径 为 %d 。 
		 注 意！ 别 站 在 爆 炸 范 围 内！( 除 非 你 学 会 了 黑 暗 共 享， 这 样 你 有 %d%% 几 率 无 视 伤 害。)]]):
		format(t.getDamage(self, t),t.radius(self,t), self:getTalentLevelRaw(self.T_DARK_EMPATHY) * 20)
	end,
}

registerTalentTranslation{
	id = "T_ASSEMBLE",
	name = "亡灵组合",
	info = function(self, t)
		return ([[将 3 个 单 位 组 合 成 1 个 骨 巨 人。 
		 在 等 级 1 时 它 可 以 制 造 1 个 骨 巨 人。 
		 在 等 级 3 时 它 可 以 制 造 1 个 重 型 骨 巨 人。 
		 在 等 级 5 时 它 可 以 制 造 1 个 不 朽 骨 巨 人。 
		 在 等 级 6 时 它 可 以 有 20%% 几 率 制 造 1 个 符 文 骨 巨 人。 
		 在 同 一 时 间 只 能 激 活 %s 。]]):
		format(necroEssenceDead(self, true) and "2 个 骨 巨 人" or "1 个 骨 巨 人")
	end,
}

registerTalentTranslation{
	id = "T_SACRIFICE",
	name = "献祭骨盾",
	info = function(self, t)
		return ([[牺 牲 1 个 骨 巨 人。 使 用 它 的 骨 头， 你 可 以 制 造 一 个 临 时 的 骨 盾， 格 挡 超 过 你 总 生 命 值 的 %d%% 的 任 何 伤 害。 
		 此 效 果 持 续 %d 回 合。]]):
		format(t.getPower(self, t), t.getTurns(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MINION_MASTERY",
	name = "亡灵精通",
	info = function(self, t)
		return ([[你 召 唤 的 每 个 亡 灵 单 位 有 概 率 进 阶:%s]]):
		format(self:callTalent(self.T_CREATE_MINIONS,"MinionChancesDesc")
		:gsub("Degenerated skeleton warrior","堕 落 骷 髅 战 士"):gsub("Skeleton warrior","骷 髅 战 士"):gsub("Armoured skeleton warrior","装 甲 骷 髅 战 士")
		:gsub("Skeleton archer","骷 髅 弓 箭 手"):gsub("Skeleton master archer","精 英 骷 髅 弓 箭 手"):gsub("Skeleton mage","骷 髅 法 师")
		:gsub("Ghoul","食 尸 鬼"):gsub("Ghast","妖 鬼"):gsub("king","王")
		:gsub("Vampire","吸 血 鬼"):gsub("Master vampire","精 英 吸 血 鬼"):gsub("Grave wight","坟 墓 尸 妖")
		:gsub("Barrow wight","古 墓 尸 妖"):gsub("Dread","梦靥"):gsub("Lich","巫妖")
		)
	end,
}


return _M
