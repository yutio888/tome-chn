local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INCINERATING_BLOWS",
	name = "焚尽强击",
	info = function(self, t)
	return ([[恶 魔 空 间 的 力 量 注 入 你 的 武 器 ： 你 的 近 战 攻 击 在 3 回 合 内 造 成 %0.2f 点 火 焰 伤 害。
	另 外 ， 每 次 攻 击 时 有 %d%% 几 率 在 %d 码 范 围 释 放 强 烈 的 火 焰 爆 发 ， 造 成 持 续 %d 回 合 的 %0.2f 点 火 焰 伤 害 。
	若 该 技 能 冷 却 完 毕 ， 则 火 焰 爆 发 将 聚 集 在 %d 码 范 围 内 ， 并 产 生 火 焰 震 慑 效 果。
	进 行 震 慑 判 定 时 ， 额 外 增 加 %d 点 法 术 强 度。
	伤 害 受 法 术 强 度 加 成。]]):
	format(t.damBonus(self, t),t.getChance(self, t),self:getTalentRadius(t),t.getDur(self, t),t.bigBonus(self, t),t.getStunRad(self,t),t.getPowerbonus(self, t))
	end,
}


registerTalentTranslation{
	id = "T_ABDUCTION",
	name = "锁魂之链",
	info = function(self, t)
	return ([[对 目 标 攻 击 ，造 成 %d%% 武 器 伤 害。
	如 果 命 中 ，将 目 标 抓 到 身 边 并 再 次 攻 击 ， 造 成 %d%% 武 器 伤 害。]]):format(100 * t.getSmallhit(self, t), 100 * t.getBighit(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_FIERY_TORMENT",
	name = "灼魂之罚",
	info = function(self, t)
	return ([[用 武 器 攻 击 敌 人 ， 造 成 %d%% 武 器 伤 害 。 如 果 命 中 ， 目 标 受 到 灼 魂 之 罚 的 影 响 ， 持 续 %d 回 合 , 火 焰 抗 性 降 低 %d%% 。
	当 灼 魂 之 罚 结 束 ， 敌 人 会 受 到 %d 点 火 焰 伤 害 。 
	在 灼 魂 之 罚 持 续 时 间 内 目 标 受 到 的 所 有 伤 害 ， 有 %d%% 会 加 成 到 火 焰 伤 害 中。
	被 灼 魂 之 罚 影 响 的 恶 魔 会 被 恶 魔 空 间 中 的 火 焰 焚 烧。]])
	:format(100 * t.getMainhit(self,t),t.getDur(self,t),t.getResist(self,t),t.getDamage(self, t),t.getPercent(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_ETERNAL_SUFFERING",
	name = "无尽苦痛",
	info = function(self, t)
	return ([[你 的 攻 击 充 溢 着 恶 毒 的 力 量 ， 能 够 延 长 敌 人 的 苦 痛 。当 近 战 命 中 时，有 %d%% 几 率 延 长 对 方 所 有 的 负 面 状 态 持 续 时 间并 降 低 所 有 正 面状 态 的 持 续 时 间 ， 增 减 幅 度 为 %d 回 合。
	该 效 果 对 同 一 目 标 每 6 回 合 才 能 生 效 一 次 。]]):format(math.min(100, t.getChance(self,t)), t.getExtend(self,t))
	end,
}


return _M
